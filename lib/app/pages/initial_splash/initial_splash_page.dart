import 'package:appflutter/app/pages/login/login_page.dart';
import 'package:flutter/material.dart';

class InitialSplashPage extends StatefulWidget {
  const InitialSplashPage({super.key});

  @override
  State<InitialSplashPage> createState() => _InitialSplashPageState();
}

class _InitialSplashPageState extends State<InitialSplashPage> {
  @override
  void initState() {
    super.initState();
    // espera 3 segundos e vai para o login
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Meu App'), // troque pelo logo do seu app
      ),
    );
  }
}
