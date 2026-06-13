import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:DasCobras/app/viewmodels/home_viewmodel/home_search_viewmodel.dart';
import 'package:DasCobras/app/pages/home/edit_product_dialog.dart';
import 'package:DasCobras/app/pages/home/add_product_dialog.dart';
import 'package:DasCobras/app/pages/client/client_page.dart';
import 'package:DasCobras/app/pages/sales/sales_page.dart';
import 'package:DasCobras/app/pages/reports/reports_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'Todos';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeSearchViewmodel>().loadProduct();
    });
  }

  Widget filterButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0D3F87) : Colors.white,
          border: Border.all(color: const Color(0xFF0D3F87)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF0D3F87),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),

            Center(
              child: Image.asset(
                'lib/app/assets/img/LogoLonga.png',
                width: 180,
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBar(
                hintText: 'Buscar produto...',
                hintStyle: const WidgetStatePropertyAll(
                  TextStyle(color: Color(0xFF0D3F87)),
                ),
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                trailing: const [Icon(Icons.search, color: Color(0xFF0D3F87))],
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF0D3F87)),
                  ),
                ),
                onChanged: (value) {
                  context.read<HomeSearchViewmodel>().searchProduct(
                    value: value,
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Consumer<HomeSearchViewmodel>(
              builder: (context, vm, _) {
                return SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: vm.categories.map((category) {
                      return filterButton(
                        text: category,
                        selected: selectedCategory == category,
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });

                          vm.filterByCategory(category);
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Consumer<HomeSearchViewmodel>(
                builder: (context, service, _) {
                  if (service.filteredProducts.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum produto encontrado',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 100),
                    itemCount: service.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = service.filteredProducts[index];

                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 15,
                          left: 5,
                          right: 5,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF0D3F87)),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF0D3F87),
                                ),
                              ),
                              child: Image.network(
                                product.imageurl,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) {
                                  return const Icon(
                                    Icons.image_not_supported_outlined,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000),
                                    ),
                                  ),

                                  Text(
                                    product.category,
                                    style: const TextStyle(
                                      color: Color(0xFF0D3F87),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Text(
                                    'R\$ ${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF28A745),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: product.stock > 0
                                          ? const Color(0xFF0D3F87)
                                          : Color(0xFFF44336),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          product.stock > 0
                                              ? Icons.inventory_2_outlined
                                              : Icons.warning_amber_rounded,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          product.stock > 0
                                              ? '${product.stock} em estoque'
                                              : 'Sem estoque',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9800),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            EditProductDialog(product: product),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF44336),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      final confirmar = await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Excluir Produto",
                                            ),
                                            content: Text(
                                              "Deseja realmente apagar o produto\n\n${product.name} ?",
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
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
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

                                          if (mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Produto removido com sucesso!",
                                                ),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Erro ao apagar: $e",
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: const Color(0xFF0D3F87),
        unselectedItemColor: const Color(0xFF0D3F87),
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0:
              break;

            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClientPage()),
              );
              break;

            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SalesPage()),
              );
              break;

            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportsPage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Venda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Relatórios',
          ),
        ],
      ),
    );
  }
}
