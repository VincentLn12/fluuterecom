import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการคำสั่งซื้อ'),
      ),
      body: const Center(
        child: Text('หน้าประวัติคำสั่งซื้อ'),
      ),
    );
  }
}
