import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'ผู้ใช้งานระบบ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('แก้ไขโปรไฟล์'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('ประวัติคำสั่งซื้อ'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text('จัดการร้านค้า / Merchant'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('เข้าสู่ระบบ / สมัครสมาชิก'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
