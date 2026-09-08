import 'package:flutter/material.dart';

class RegisterShopPage extends StatelessWidget {
  const RegisterShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนร้านค้า'),
      ),
      body: const Center(
        child: Text('หน้าลงทะเบียนร้านค้าใหม่'),
      ),
    );
  }
}
