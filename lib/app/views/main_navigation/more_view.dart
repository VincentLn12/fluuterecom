import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('เมนูเพิ่มเติม'),
        actions: [
          IconButton(
            onPressed: () {
              authController.logout();
              Get.offAllNamed(AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Tile(
            title: 'มิเตอร์น้ำและไฟ',
            icon: Icons.speed_outlined,
            onTap: () => Get.toNamed(AppRoutes.utilityMeters),
          ),
          _Tile(
            title: 'แจ้งซ่อม',
            icon: Icons.build_circle_outlined,
            onTap: () => Get.toNamed(AppRoutes.maintenance),
          ),
          _Tile(
            title: 'ตั้งค่าระบบ',
            icon: Icons.settings_outlined,
            onTap: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _Tile({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
