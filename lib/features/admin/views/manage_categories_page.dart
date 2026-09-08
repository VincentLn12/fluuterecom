import 'package:flutter/material.dart';

class ManageCategoriesPage extends StatelessWidget {
  const ManageCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการหมวดหมู่'),
      ),
      body: const Center(
        child: Text('หน้าจัดการหมวดหมู่สำหรับ Admin'),
      ),
    );
  }
}
