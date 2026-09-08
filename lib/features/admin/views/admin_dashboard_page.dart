import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ผู้ดูแลระบบ (Admin Dashboard)'),
      ),
      body: const Center(
        child: Text('หน้า Dashboard ผู้ดูแลระบบ'),
      ),
    );
  }
}
