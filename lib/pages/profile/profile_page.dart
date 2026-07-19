import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/recipe_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../utils/constants.dart';
import '../auth/auth_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeController = Get.find<RecipeController>();
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('โปรไฟล์')),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            Obx(
              () {
                final user = authController.currentUser.value;
                return Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48.r,
                        backgroundImage: const AssetImage(AppConstants.defaultProfileAsset),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        user?.name ?? 'ยังไม่ได้เข้าสู่ระบบ',
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        user?.email ?? 'กรุณาเข้าสู่ระบบ',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      if (user != null)
                        Chip(
                          avatar: Icon(
                            user.isAdmin ? Icons.admin_panel_settings : Icons.person,
                          ),
                          label: Text(user.isAdmin ? 'Admin' : 'User'),
                        ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      label: authController.currentUser.value?.isAdmin == true ? 'จัดการได้ทั้งหมด' : 'สูตรของฉัน',
                      value: recipeController.myRecipeCount().toString(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatBox(
                      label: 'สูตรโปรด',
                      value: recipeController.favoriteRecipes.length.toString(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'สลับบัญชีสำหรับทดสอบสิทธิ์',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => Column(
                children: authController.users.map((user) {
                  final selected = user.id == authController.currentUser.value?.id;
                  return ListTile(
                    onTap: () => authController.switchUser(user),
                    leading: Icon(
                      selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.isAdmin ? 'Admin: CRUD ได้ทุกสูตร' : 'User: CRUD ได้เฉพาะสูตรตัวเอง'),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            Obx(
              () => SwitchListTile(
                value: themeController.isDarkMode.value,
                onChanged: themeController.toggleTheme,
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('Dark Mode'),
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('เกี่ยวกับแอป'),
              subtitle: Text('โปรเจคฝึก Flutter Syntax และ GetX'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('ล้างข้อมูล'),
              subtitle: const Text('โหลดข้อมูลใหม่จาก json-server'),
              onTap: recipeController.fetchRecipes,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('ออกจากระบบ'),
              subtitle: const Text('กลับไปหน้า Login'),
              onTap: () {
                authController.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const AuthPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: 4.h),
          Text(label),
        ],
      ),
    );
  }
}
