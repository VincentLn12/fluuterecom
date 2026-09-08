import 'package:flutter/material.dart';

class ManageTagsPage extends StatelessWidget {
  const ManageTagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการแท็ก'),
      ),
      body: const Center(
        child: Text('หน้าจัดการแท็กสำหรับ Admin'),
      ),
    );
  }
}
