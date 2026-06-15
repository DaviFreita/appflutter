import 'package:DasCobras/app/pages/widgets/shared/logo_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sales_history_page.dart';

import 'package:DasCobras/app/viewmodels/home_viewmodel/home_search_viewmodel.dart';
import 'package:DasCobras/app/pages/home/home_page.dart';
import 'package:DasCobras/app/pages/reports/reports_page.dart';
import '../../model/customer_model.dart';
import '../../viewmodels/client_viewmodel/client_viewmodel.dart';
import 'package:DasCobras/app/pages/client/client_page.dart';
import 'package:DasCobras/app/pages/client/view_client_dialog.dart';
import '../../viewmodels/sale_viewmodel/sale_viewmodel.dart';
import 'cart_dialog.dart';
import 'package:DasCobras/app/pages/sales/add_product_cart_dialog.dart';
import 'package:DasCobras/app/pages/widgets/home/custom_bottom_nav.dart';
import 'package:DasCobras/app/pages/widgets/sales/sales_floating_buttons.dart';
import 'package:DasCobras/app/pages/widgets/sales/sales_product_card.dart';
import 'package:DasCobras/app/pages/widgets/sales/selected_client_card.dart';
import 'package:DasCobras/app/pages/widgets/shared/client_search_bar.dart';
import 'package:DasCobras/app/pages/widgets/sales/customer_search_results.dart';
import 'package:DasCobras/app/pages/widgets/shared/product_search_bar.dart';
import 'package:DasCobras/app/pages/widgets/shared/category_filter.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  CustomerModel? selectedCustomer;

  final TextEditingController clientSearchController = TextEditingController();
  String selectedCategory = 'Todos';
  String selectedOrder = 'Mais relevantes';
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeSearchViewmodel>().loadProduct();
      context.read<ClientViewModel>().loadCustomers();
    });
  }

  @override
  void dispose() {
    clientSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),

            const LogoHeader(),

            const SizedBox(height: 15),

            ClientSearchBar(
              controller: clientSearchController,
              onChanged: (value) {
                context.read<ClientViewModel>().searchCustomer(value);
                setState(() {});
              },
            ),

            const SizedBox(height: 10),

            if (selectedCustomer != null)
              SelectedClientCard(
                name: selectedCustomer!.name,
                cpfOrCnpj: selectedCustomer!.cpforcnpj,
                onDetails: () {
                  showDialog(
                    context: context,
                    builder: (_) => ViewClientDialog(client: selectedCustomer!),
                  );
                },
                onRemove: () {
                  setState(() {
                    selectedCustomer = null;
                  });

                  context.read<SaleViewModel>().removeCustomer();
                  context.read<ClientViewModel>().searchCustomer('');
                },
              ),

            const SizedBox(height: 0),

            Consumer<ClientViewModel>(
              builder: (context, clientVm, _) {
                if (selectedCustomer != null ||
                    clientSearchController.text.trim().isEmpty) {
                  return const SizedBox();
                }

                return CustomerSearchResults(
                  customers: clientVm.filteredCustomers,
                  onSelect: (client) {
                    setState(() {
                      selectedCustomer = client;

                      clientSearchController.clear();

                      context.read<SaleViewModel>().setCustomer(client);
                    });

                    context.read<ClientViewModel>().searchCustomer('');
                  },
                );
              },
            ),

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

                      return SalesProductCard(
                        product: product,
                        onAdd: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                AddProductCartDialog(product: product),
                          );
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

      floatingActionButton: Consumer<SaleViewModel>(
        builder: (context, saleVm, _) {
          return SalesFloatingButtons(
            cartCount: saleVm.cart.length,
            onHistory: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SalesHistoryPage()),
              );
            },
            onCart: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          );
        },
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2, // Tela de Venda
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
              break;

            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ClientPage()),
              );
              break;

            case 2:
              break; // Já está na tela de venda

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
