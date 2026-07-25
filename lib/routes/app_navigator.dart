import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../models/recipe.dart';
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

  static void openRecipeDetail(Recipe recipe) {
    Get.toNamed(AppRoutes.recipeDetail, arguments: recipe);
  }

  static bool _isInsideMainTabs() => mainTabs.contains(Get.currentRoute);
}
