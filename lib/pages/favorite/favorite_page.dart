import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/recipe_controller.dart';
import '../../routes/app_routes.dart';
import '../../routes/app_navigator.dart';
import '../../models/recipe.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/recipe_card.dart';

class FavoritePage extends GetView<RecipeController> {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('รายการโปรด')),
      body: SafeArea(
        child: Obx(() {
          if (!authController.isLoggedIn) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: 'เข้าสู่ระบบเพื่อใช้รายการโปรด',
              message: 'รายการโปรดจะแยกตามบัญชีของแต่ละคน',
              buttonText: 'เข้าสู่ระบบ',
              onPressed: () => Get.toNamed(AppRoutes.auth),
            );
          }
          if (controller.favoriteRecipes.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: 'ยังไม่มีรายการโปรด',
              message: 'กดหัวใจบนสูตรอาหารเพื่อเก็บไว้ดูภายหลัง',
              buttonText: 'ไปหน้าแรก',
              onPressed: () => AppNavigator.goToTab(0),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.favoriteRecipes.length,
            itemBuilder: (context, index) {
              final recipe = controller.favoriteRecipes[index];
              return RecipeCard(
                recipe: recipe,
                onTap: () => _openDetail(context, recipe),
                onFavoritePressed: () => controller.toggleFavorite(recipe),
              );
            },
          );
        }),
      ),
    );
  }

  void _openDetail(BuildContext context, Recipe recipe) {
    AppNavigator.openRecipeDetail(context, recipe);
  }
}
