import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:DasCobras/app/model/product_search_model.dart';

class HomeSearchViewmodel extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<ProductSearchModel> products = [];
  List<ProductSearchModel> filteredProducts = [];

  Future<void> loadProduct() async {
    try {
      final response = await supabase.from('product').select('''
      *,
      category!product_category_id_fkey (
        id,
        name
      )
    ''');

      products = response.map((e) => ProductSearchModel.fromMap(e)).toList();

      filteredProducts = List.from(products);

      notifyListeners();
    } catch (e) {
      print("ERRO AO CARREGAR PRODUTOS");
      print(e);
    }
  }

  Future<void> searchProduct({required String value}) async {
    try {
      if (value.trim().isEmpty) {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products.where((product) {
          return product.name.toLowerCase().contains(value.toLowerCase());
        }).toList();
      }

      notifyListeners();
    } catch (e) {
      print("ERRO NA BUSCA");
      print(e);
    }
  }

  Future<void> filterByCategory(String category) async {
    if (category == 'Todos') {
      filteredProducts = List.from(products);
    } else {
      filteredProducts = products.where((product) {
        return product.category == category;
      }).toList();
    }

    notifyListeners();
  }

  Future<void> addProduct({
    required String name,
    required String imageurl,
    required double price,
    required int stock,
    required int categoryId,
  }) async {
    await supabase.from('product').insert({
      'name': name,
      'imageurl': imageurl,
      'price': price,
      'stock': stock,
      'category_id': categoryId,
    });

    await loadProduct();
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required double price,
    required int stock,
    required int categoryId,
  }) async {
    try {
      print("========== UPDATE ==========");
      print("ID: $id");
      print("Nome: $name");
      print("Preço: $price");
      print("Estoque: $stock");
      print("Categoria: $categoryId");

      final response = await supabase
          .from('product')
          .update({
            'name': name,
            'price': price,
            'stock': stock,
            'category_id': categoryId,
          })
          .eq('id', id)
          .select();

      print("RESPOSTA UPDATE:");
      print(response);

      await loadProduct();
    } catch (e, s) {
      print("ERRO AO ATUALIZAR");
      print(e);
      print(s);

      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    await supabase.from('product').delete().eq('id', id);

    await loadProduct();
  }
}
