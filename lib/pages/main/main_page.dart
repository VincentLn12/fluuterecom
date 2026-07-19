import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/navigation_controller.dart';
import '../favorite/favorite_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../recipe_form/recipe_form_page.dart';
import '../search/search_page.dart';

class MainPage extends GetView<NavigationController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const SearchPage(),
      const RecipeFormPage(),
      const FavoritePage(),
      const ProfilePage(),
    ];
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'หน้าแรก'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'ค้นหา'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'เพิ่มสูตร'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'รายการโปรด'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'โปรไฟล์'),
          ],
        ),
      ),
    );
  }
}
