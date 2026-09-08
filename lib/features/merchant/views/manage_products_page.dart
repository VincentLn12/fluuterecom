import 'package:flutter/material.dart';

class ManageProductsPage extends StatelessWidget {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการสินค้า'),
      ),
      body: const Center(
        child: Text('หน้าจัดการสินค้าในร้าน'),
      ),
    );
  }
}
