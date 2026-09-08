import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขโปรไฟล์'),
      ),
      body: const Center(
        child: Text('หน้าแก้ไขโปรไฟล์'),
      ),
    );
  }
}
