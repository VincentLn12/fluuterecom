import 'package:flutter/material.dart';

class ManageAdminContentsPage extends StatelessWidget {
  const ManageAdminContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการเนื้อหา (Admin)'),
      ),
      body: const Center(
        child: Text('หน้าจัดการบทความ/เนื้อหาสำหรับ Admin'),
      ),
    );
  }
}
