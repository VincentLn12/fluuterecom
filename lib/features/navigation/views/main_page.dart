import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../../home/views/home_page.dart';
import '../../shops/views/shops_page.dart';
import '../../contents/views/contents_page.dart';
import '../../cart/views/cart_page.dart';
import '../../profile/views/profile_page.dart';

class MainPage extends GetView<NavigationController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomePage(),
      ShopsPage(),
      ContentsPage(),
      CartPage(),
      ProfilePage(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'หน้าแรก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'ร้านค้า',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article),
              label: 'เนื้อหา',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'ตะกร้า',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'โปรไฟล์',
            ),
          ],
        ),
      ),
    );
  }
}
