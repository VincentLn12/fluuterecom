import 'package:get/get.dart';

import '../models/recipe.dart';
import '../pages/auth/auth_page.dart';
import '../pages/main/main_page.dart';
import '../pages/recipe_detail/recipe_detail_page.dart';
import '../pages/recipe_form/recipe_form_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/admin/admin_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(name: AppRoutes.auth, page: () => const AuthPage()),
    GetPage(name: AppRoutes.home, page: () => const MainPage(initialIndex: 0)),
    GetPage(name: AppRoutes.search, page: () => const MainPage(initialIndex: 1)),
    GetPage(name: AppRoutes.myRecipes, page: () => const MainPage(initialIndex: 2)),
    GetPage(name: AppRoutes.favorite, page: () => const MainPage(initialIndex: 3)),
    GetPage(name: AppRoutes.profile, page: () => const MainPage(initialIndex: 4)),
    GetPage(
      name: AppRoutes.recipeDetail,
      page: () {
        final argument = Get.arguments;
        return RecipeDetailPage(
          recipe: argument is Recipe ? argument : null,
          recipeId: argument is int ? argument : int.tryParse(argument?.toString() ?? ''),
        );
      },
    ),
    GetPage(
      name: AppRoutes.recipeForm,
      page: () => RecipeFormPage(recipe: Get.arguments as Recipe?),
    ),
    GetPage(
      name: AppRoutes.admin,
      page: () => const AdminPage(),
    ),
  ];
}
