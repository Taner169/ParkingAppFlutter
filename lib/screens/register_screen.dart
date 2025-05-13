import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrera användare")),
      body: const Center(child: Text("Här kan nya användare registrera sig.")),
    );
  }
}
