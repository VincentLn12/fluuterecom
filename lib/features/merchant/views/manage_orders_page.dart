import 'package:flutter/material.dart';

class ManageOrdersPage extends StatelessWidget {
  const ManageOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการออเดอร์ร้านค้า'),
      ),
      body: const Center(
        child: Text('หน้าจัดการคำสั่งซื้อร้านค้า'),
      ),
    );
  }
}
