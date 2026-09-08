import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import 'favorite_page.dart';
import 'home_page.dart';
import 'my_recipes_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    final pages = const [
      HomePage(),
      SearchPage(),
      MyRecipesPage(),
      FavoritePage(),
      ProfilePage(),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'หน้าแรก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'ค้นหา',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'สูตรของฉัน',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'รายการโปรด',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'โปรไฟล์',
            ),
          ],
        ),
      ),
    );
  }
}
