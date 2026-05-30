import 'package:appflutter/app/pages/home/home_page.dart';
import 'package:appflutter/app/pages/register/register_page.dart';
import 'package:appflutter/app/viewmodels/auth_service.dart';
import 'package:flutter/material.dart';

final TextEditingController _emailController = TextEditingController();
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
                controller: _emailController,

                decoration: const InputDecoration(labelText: 'Email'),
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
                    final ApiService = AuthService();

                    await ApiService.login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

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
