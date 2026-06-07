class CustomerModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String cpforcnpj;
  final String city;
  final String state;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.cpforcnpj,
    required this.city,
    required this.state,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      cpforcnpj: map['cpforcnpj'] ?? '',
      city: map['city'] ?? '',
      state: map['state_'] ?? '',
    );
  }
}
