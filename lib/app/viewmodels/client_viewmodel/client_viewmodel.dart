import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/customer_model.dart';

class ClientViewModel extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<CustomerModel> customers = [];
  List<CustomerModel> filteredCustomers = [];

  Future<void> loadCustomers() async {
    try {
      final response = await supabase.from('customer').select();

      customers = response
          .map<CustomerModel>((e) => CustomerModel.fromMap(e))
          .toList();

      filteredCustomers = List.from(customers);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void searchCustomer(String value) {
    if (value.trim().isEmpty) {
      filteredCustomers = List.from(customers);
    } else {
      filteredCustomers = customers.where((customer) {
        return customer.name.toLowerCase().contains(value.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}
