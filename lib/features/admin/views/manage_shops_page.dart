import 'package:flutter/material.dart';

class ManageShopsPage extends StatelessWidget {
  const ManageShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('อนุมัติ/จัดการร้านค้า'),
      ),
      body: const Center(
        child: Text('หน้าจัดการร้านค้าสำหรับ Admin'),
      ),
    );
  }
}
