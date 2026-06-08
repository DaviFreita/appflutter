import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/client_viewmodel/client_viewmodel.dart';

class CreateClientDialog extends StatefulWidget {
  const CreateClientDialog({super.key});

  @override
  State<CreateClientDialog> createState() => _CreateClientDialogState();
}

class _CreateClientDialogState extends State<CreateClientDialog> {
  final nameController = TextEditingController();
  final cpfController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final houseNumberController = TextEditingController();
  final cepController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  bool loading = false;

  Future<void> saveCustomer() async {
    try {
      setState(() => loading = true);

      await context.read<ClientViewModel>().addCustomer(
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
          const SnackBar(content: Text("Cliente cadastrado com sucesso!")),
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
                "Criar Cliente",
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF0D3F87),
                  fontWeight: FontWeight.bold,
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

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D3F87),
                  ),
                  onPressed: loading
                      ? null
                      : () async {
                          try {
                            await saveCustomer();
                            print("CLIENTE SALVO");
                          } catch (e) {
                            print("ERRO AO SALVAR:");
                            print(e);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Salvar Cliente",
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
