import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/recipe_controller.dart';
import '../../models/recipe.dart';
import '../../routes/app_navigator.dart';
import '../../routes/app_routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/recipe_card.dart';

class MyRecipesPage extends GetView<RecipeController> {
  const MyRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            authController.currentUser.value?.isAdmin == true
                ? 'จัดการสูตรทั้งหมด'
                : 'สูตรของฉัน',
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => authController.isLoggedIn
            ? FloatingActionButton.extended(
                onPressed: _openForm,
                icon: const Icon(Icons.add),
                label: const Text('เพิ่มสูตรอาหาร'),
              )
            : const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Obx(() {
          if (!authController.isLoggedIn) {
            return EmptyState(
              icon: Icons.lock_outline,
              title: 'กรุณาเข้าสู่ระบบ',
              message: 'ต้องเข้าสู่ระบบก่อนดูและจัดการสูตรของฉัน',
              buttonText: 'เข้าสู่ระบบ',
              onPressed: () => Get.toNamed(AppRoutes.auth),
            );
          }

          final recipes = controller.manageableRecipes();
          if (recipes.isEmpty) {
            return EmptyState(
              icon: Icons.menu_book_outlined,
              title: authController.currentUser.value?.isAdmin == true
                  ? 'ยังไม่มีสูตรอาหาร'
                  : 'ยังไม่มีสูตรของคุณ',
              message: 'กดปุ่มเพิ่มสูตรอาหารเพื่อเริ่มสร้างเมนูแรก',
              buttonText: 'เพิ่มสูตรอาหาร',
              onPressed: _openForm,
            );
          }
          return ListView(
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 96.h),
            children: [
              _MyRecipeSummary(
                count: recipes.length,
                isAdmin: authController.currentUser.value?.isAdmin == true,
              ),
              SizedBox(height: 18.h),
              ...recipes.map(
                (recipe) => RecipeCard(
                  recipe: recipe,
                  onTap: () => _openDetail(context, recipe),
                  onFavoritePressed: () => controller.toggleFavorite(recipe),
                  onEditPressed: () => _confirmEdit(recipe),
                  onDeletePressed: () => controller.deleteRecipe(recipe),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _confirmEdit(Recipe recipe) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('ยืนยันการแก้ไข'),
        content: Text('ต้องการแก้ไข "${recipe.name}" ใช่ไหม'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('แก้ไข'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _openForm(recipe);
    }
  }

  void _openForm([Recipe? recipe]) {
    Get.toNamed(AppRoutes.recipeForm, arguments: recipe);
  }

  void _openDetail(BuildContext context, Recipe recipe) {
    AppNavigator.openRecipeDetail(context, recipe);
  }
}

class _MyRecipeSummary extends StatelessWidget {
  const _MyRecipeSummary({required this.count, required this.isAdmin});

  final int count;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.24),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAdmin ? 'สูตรทั้งหมดในระบบ' : 'คลังสูตรของคุณ',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '$count สูตรอาหาร',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAdmin ? Icons.admin_panel_settings : Icons.menu_book_rounded,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
        ],
      ),
    );
  }
}
