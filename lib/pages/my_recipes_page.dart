import 'package:flutter/material.dart';

class MyRecipesPage extends StatelessWidget {
  const MyRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สูตรของฉัน'),
      ),
      body: const Center(
        child: Text('สูตรของฉัน'),
      ),
    );
  }
}
