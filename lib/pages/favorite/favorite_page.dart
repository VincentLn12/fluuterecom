import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/navigation_controller.dart';
import '../../controllers/recipe_controller.dart';
import '../../models/recipe.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/recipe_card.dart';
import '../recipe_detail/recipe_detail_page.dart';

class FavoritePage extends GetView<RecipeController> {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายการโปรด')),
      body: SafeArea(
        child: Obx(() {
          if (controller.favoriteRecipes.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: 'ยังไม่มีรายการโปรด',
              message: 'กดหัวใจบนสูตรอาหารเพื่อเก็บไว้ดูภายหลัง',
              buttonText: 'ไปหน้าแรก',
              onPressed: () => Get.find<NavigationController>().changeIndex(0),
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
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const RecipeDetailPage(),
        settings: RouteSettings(arguments: recipe),
      ),
    );
  }
}
