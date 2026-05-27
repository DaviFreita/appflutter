import 'package:appflutter/app/pages/home/home_page.dart';
import 'package:appflutter/app/pages/register/register_page.dart';
import 'package:appflutter/app/utils/utils_validators.dart';
import 'package:appflutter/app/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

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

              ElevatedButton(
                onPressed: () async {
                  try {
                    final authService = ApiService();

                    final token = await authService.login(
                      cpf: _cpfController.text,
                      password: _passwordController.text,
                    );

                    final prefs = await SharedPreferences.getInstance();

                    await prefs.setString('token', token);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login realizado com sucesso'),
                      ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: const Text('Entrar'),
              ),

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
