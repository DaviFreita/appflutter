import 'package:appflutter/app/pages/register/register_page.dart';
import 'package:appflutter/app/utils/utils_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final TextEditingController _cpfController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'lib/app/assets/img/Logo.png',
                width: 200,
                height: 200,
              ),

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
              ),

              const SizedBox(height: 30),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,

                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },

                child: const Text('Não possui conta? Faça seu registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
