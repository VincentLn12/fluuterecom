import 'package:flutter/material.dart';

class ShopDetailPage extends StatelessWidget {
  const ShopDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดร้านค้า'),
      ),
      body: const Center(
        child: Text('หน้ารายละเอียดร้านค้า'),
      ),
    );
  }
}
