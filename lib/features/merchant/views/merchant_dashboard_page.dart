import 'package:flutter/material.dart';

class MerchantDashboardPage extends StatelessWidget {
  const MerchantDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการร้านค้า (Merchant)'),
      ),
      body: const Center(
        child: Text('หน้า Dashboard ผู้ประกอบการ'),
      ),
    );
  }
}
