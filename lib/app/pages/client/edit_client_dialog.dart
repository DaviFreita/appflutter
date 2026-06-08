import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/customer_model.dart';
import '../../viewmodels/client_viewmodel/client_viewmodel.dart';

class EditClientDialog extends StatefulWidget {
  final CustomerModel client;

  const EditClientDialog({super.key, required this.client});

  @override
  State<EditClientDialog> createState() => _EditClientDialogState();
}

class _EditClientDialogState extends State<EditClientDialog> {
  late TextEditingController nameController;
  late TextEditingController cpfController;
  late TextEditingController birthDateController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController houseNumberController;
  late TextEditingController cepController;
  late TextEditingController neighborhoodController;
  late TextEditingController cityController;
  late TextEditingController stateController;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.client.name);
    cpfController = TextEditingController(text: widget.client.cpforcnpj);
    birthDateController = TextEditingController(text: widget.client.birthDate);
    phoneController = TextEditingController(text: widget.client.phone);
    emailController = TextEditingController(text: widget.client.email);

    addressController = TextEditingController(text: widget.client.address);

    houseNumberController = TextEditingController(
      text: widget.client.houseNumber,
    );

    cepController = TextEditingController(text: widget.client.cep);

    neighborhoodController = TextEditingController(
      text: widget.client.neighborhood,
    );

    cityController = TextEditingController(text: widget.client.city);
    stateController = TextEditingController(text: widget.client.state);
  }

  Future<void> updateCustomer() async {
    try {
      setState(() => loading = true);

      await context.read<ClientViewModel>().updateCustomer(
        id: widget.client.id,
        name: nameController.text,
        birthDate: birthDateController.text,
        phone: phoneController.text,
        email: emailController.text,
        cpfOrCnpj: cpfController.text,
        state: stateController.text,
        city: cityController.text,
        neighborhood: neighborhoodController.text,
        cep: cepController.text,
        houseNumber: houseNumberController.text,
        address: addressController.text,
      );

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cliente atualizado com sucesso!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Editar Cliente",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D3F87),
                ),
              ),

              const SizedBox(height: 20),

              buildField("Nome", nameController),

              buildField("CPF/CNPJ", cpfController),

              buildField("Data de nascimento", birthDateController),

              buildField("Telefone", phoneController),

              buildField("Email", emailController),

              buildField("Rua", addressController),

              Row(
                children: [
                  Expanded(child: buildField("Número", houseNumberController)),
                  const SizedBox(width: 10),
                  Expanded(child: buildField("CEP", cepController)),
                ],
              ),

              buildField("Bairro", neighborhoodController),

              Row(
                children: [
                  Expanded(child: buildField("Cidade", cityController)),
                  const SizedBox(width: 10),
                  Expanded(child: buildField("Estado", stateController)),
                ],
              ),
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D3F87),
                  ),
                  onPressed: loading ? null : updateCustomer,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Salvar Alterações",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
