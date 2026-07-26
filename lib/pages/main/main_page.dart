import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/navigation_controller.dart';
import '../../routes/app_navigator.dart';
import '../favorite/favorite_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../recipe_form/my_recipes_page.dart';
import '../search/search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({required this.initialIndex, super.key});

  final int initialIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final NavigationController controller = Get.find<NavigationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.setIndex(widget.initialIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const SearchPage(),
      const MyRecipesPage(),
      const FavoritePage(),
      const ProfilePage(),
    ];
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: AppNavigator.goToTab,
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
        ),
      ),
    );
  }
}
