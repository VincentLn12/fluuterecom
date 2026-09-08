import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดคำสั่งซื้อ'),
      ),
      body: const Center(
        child: Text('หน้ารายละเอียดคำสั่งซื้อ'),
      ),
    );
  }
}
