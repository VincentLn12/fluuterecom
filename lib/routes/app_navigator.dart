import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../models/recipe.dart';
import '../pages/recipe_detail/recipe_detail_page.dart';
import 'app_routes.dart';

class AppNavigator {
  static const mainTabs = [
    AppRoutes.home,
    AppRoutes.search,
    AppRoutes.myRecipes,
    AppRoutes.favorite,
    AppRoutes.profile,
  ];

  static void goToTab(int index) {
    if (index < 0 || index >= mainTabs.length) {
      return;
    }

    if (Get.isRegistered<NavigationController>() && _isInsideMainTabs()) {
      Get.find<NavigationController>().setIndex(index);
      return;
    }

    Get.offNamed(mainTabs[index]);
  }

  static void goToRoute(String route) {
    final index = mainTabs.indexOf(route);
    if (index != -1) {
      goToTab(index);
      return;
    }
    Get.toNamed(route);
  }

  static void openRecipeDetail(BuildContext context, Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => RecipeDetailPage(recipe: recipe)),
    );
  }

  static bool _isInsideMainTabs() => mainTabs.contains(Get.currentRoute);
}
