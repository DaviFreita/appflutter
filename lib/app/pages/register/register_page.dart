import 'package:appflutter/app/utils/utils_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appflutter/app/viewmodels/auth_registermodel.dart';
import 'package:appflutter/app/pages/login/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthRegistermodel viewModel = AuthRegistermodel();

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  final TextEditingController _cpfController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              //campo do nome
              TextFormField(
                controller: nameController,

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ ]')),
                ],

                decoration: const InputDecoration(labelText: 'Nome Completo'),

                validator: (value) => UtilsValidators.name(value),
              ),
              const SizedBox(height: 20),

              //campo do cpf
              TextFormField(
                controller: _cpfController,

                keyboardType: TextInputType.number,

                decoration: const InputDecoration(labelText: 'CPF'),

                inputFormatters: [UtilsValidators().cpfMaskFormatter],

                validator: (value) => UtilsValidators.cpf(value),
              ),

              const SizedBox(height: 20),

              //campo de Senha
              TextFormField(
                controller: _passwordController,
                obscureText: true,

                decoration: const InputDecoration(labelText: 'Senha'),

                validator: (value) => UtilsValidators.password(value),
              ),

              const SizedBox(height: 30),

              //campo de data
              TextFormField(
                controller: _dateController,
                readOnly: true, //vai impedir do usuario diigtar

                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                  suffix: Icon(Icons.calendar_today),
                ),

                onTap: () async {
                  //enquanto o usuario clicar
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _dateController.text =
                        '${date.day}/${date.month}/${date.year}';
                  }
                },

                validator: (value) => UtilsValidators.Birth(value),
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await viewModel.register(
                      name: nameController.text,
                      cpf: _cpfController.text,
                      password: _passwordController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuário cadastrado')),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }
                },

                child: const Text('Cadastrar'),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,

                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },

                child: const Text('Já possui conta? Faça login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
