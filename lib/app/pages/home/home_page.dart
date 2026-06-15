import 'package:DasCobras/app/pages/sales/sales_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:DasCobras/app/viewmodels/home_viewmodel/home_search_viewmodel.dart';
import 'package:DasCobras/app/pages/home/edit_product_dialog.dart';
import 'package:DasCobras/app/pages/home/add_product_dialog.dart';
import 'package:DasCobras/app/pages/client/client_page.dart';
import 'package:DasCobras/app/pages/reports/reports_page.dart';
import 'package:DasCobras/app/pages/widgets/home/custom_bottom_nav.dart';
import 'package:DasCobras/app/pages/widgets/home/product_car_dialog.dart';
import 'package:DasCobras/app/pages/widgets/shared/logo_header.dart';
import 'package:DasCobras/app/pages/widgets/shared/product_search_bar.dart';
import 'package:DasCobras/app/pages/widgets/shared/category_filter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'Todos';
  String selectedOrder = 'Mais relevantes';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeSearchViewmodel>().loadProduct(force: true);
    });
  }

  final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            const LogoHeader(),

            const SizedBox(height: 15),

            ProductSearchBar(
              onSearch: (value) {
                context.read<HomeSearchViewmodel>().searchProduct(value: value);
              },
            ),

            const SizedBox(height: 10),

            Consumer<HomeSearchViewmodel>(
              builder: (context, vm, _) {
                return CategoryFilter(
                  categories: vm.categories,
                  selectedCategory: selectedCategory,
                  selectedOrder: selectedOrder,
                  onCategorySelected: (category) {
                    setState(() => selectedCategory = category);
                    vm.filterByCategory(category);
                  },
                  onOrderSelected: (order) {
                    setState(() => selectedOrder = order);
                    vm.orderProducts(order);
                  },
                );
              },
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Consumer<HomeSearchViewmodel>(
                builder: (context, service, _) {
                  if (service.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (service.filteredProducts.isEmpty) {
                    return const Center(
                      child: Text('Nenhum produto encontrado'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 100),
                    itemCount: service.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = service.filteredProducts[index];

                      final Color stockColor = product.stock == 0
                          ? Colors.red
                          : product.stock <= 10
                          ? Colors.orange
                          : const Color(0xFF0D3F87);

                      final String stockText = product.stock == 0
                          ? 'Sem estoque'
                          : product.stock <= 10
                          ? 'Últimas ${product.stock} unidades'
                          : '${product.stock} em estoque';

                      return ProductCard(
                        product: product,
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                EditProductDialog(product: product),
                          );
                        },
                        onDelete: () async {
                          final confirmar = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Excluir Produto"),
                                content: Text(
                                  "Este produto deixará de aparecer nas vendas e no estoque. Deseja continuar?\n\n${product.name}",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text("Não"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text(
                                      "Sim",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmar == true) {
                            try {
                              await context
                                  .read<HomeSearchViewmodel>()
                                  .deleteProduct(product.id);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Produto removido com sucesso!",
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erro ao apagar: $e")),
                                );
                              }
                            }
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D3F87),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddProductDialog(),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 35),
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0, // Home
        onTap: (index) {
          switch (index) {
            case 0:
              break;

            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ClientPage()),
              );
              break;

            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SalesPage()),
              );
              break;

            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ReportsPage()),
              );
              break;
          }
        },
      ),
    );
  }
}
