import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/recipe.dart';
import 'recipe_controller.dart';
import '../routes/app_routes.dart';

class RecipeDetailController extends GetxController {
  RecipeDetailController({this.initialRecipe, this.initialRecipeId});

  final Recipe? initialRecipe;
  final int? initialRecipeId;

  final recipe = Rxn<Recipe>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final servings = 1.obs;

  RecipeController get _recipeController => Get.find<RecipeController>();

  @override
  void onInit() {
    super.onInit();
    recipe.value = initialRecipe;
    servings.value = _safeServings(recipe.value?.servings);
    loadRecipe();
  }

  Recipe? get latestRecipe {
    final currentRecipe = recipe.value;
    if (currentRecipe?.id == null || !Get.isRegistered<RecipeController>()) {
      return currentRecipe;
    }
    return _recipeController.recipes.firstWhereOrNull(
          (item) => item.id == currentRecipe!.id,
        ) ??
        currentRecipe;
  }

  bool get canManage {
    final currentRecipe = latestRecipe;
    if (currentRecipe == null) return false;
    return _recipeController.canManageRecipe(currentRecipe);
  }

  double get multiplier {
    final currentRecipe = latestRecipe;
    if (currentRecipe == null) return 1.0;
    return servings.value / _safeServings(currentRecipe.servings);
  }

  void increaseServings() {
    servings.value++;
  }

  void decreaseServings() {
    if (servings.value > 1) {
      servings.value--;
    }
  }

  Future<void> loadRecipe() async {
    final recipeId = recipe.value?.id ?? initialRecipeId;
    if (recipe.value != null && initialRecipeId == null) {
      return;
    }
    if (recipeId == null) {
      errorMessage.value = '';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetched = await _recipeController.fetchRecipeById(recipeId);
      recipe.value = fetched;
      servings.value = _safeServings(fetched.servings);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    final currentRecipe = latestRecipe;
    if (currentRecipe == null) return;
    await _recipeController.toggleFavorite(currentRecipe);
    recipe.value = latestRecipe;
  }

  Future<void> confirmEdit() async {
    final currentRecipe = latestRecipe;
    if (currentRecipe == null) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('ยืนยันการแก้ไข'),
        content: Text('ต้องการแก้ไข "${currentRecipe.name}" ใช่ไหม'),
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
      Get.toNamed(AppRoutes.recipeForm, arguments: currentRecipe);
    }
  }

  Future<void> deleteRecipe() async {
    final currentRecipe = latestRecipe;
    if (currentRecipe == null) return;
    final deleted = await _recipeController.deleteRecipe(currentRecipe);
    if (deleted) {
      Get.back();
    }
  }

  Future<void> openVideo() async {
    final currentRecipe = latestRecipe;
    if (currentRecipe == null) return;
    final url = currentRecipe.videoUrl.trim();
    final uri = Uri.tryParse(url);
    if (uri == null) {
      Get.snackbar('ลิงก์ไม่ถูกต้อง', 'ไม่สามารถเปิดวิดีโอนี้ได้');
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    if (!opened) {
      Get.snackbar('เปิดลิงก์ไม่ได้', 'กรุณาลองคัดลอกลิงก์แล้วเปิดเอง');
    }
  }

  Future<void> copyVideoLink() async {
    final currentRecipe = latestRecipe;
    if (currentRecipe == null) return;
    final url = currentRecipe.videoUrl.trim();
    await Clipboard.setData(ClipboardData(text: url));
    Get.snackbar('คัดลอกแล้ว', 'คัดลอกลิงก์วิดีโอเรียบร้อย');
  }

  int _safeServings(int? value) {
    if (value == null || value < 1) {
      return 1;
    }
    return value;
  }
}
