import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดสินค้า'),
      ),
      body: const Center(
        child: Text('หน้ารายละเอียดสินค้า'),
      ),
    );
  }
}
