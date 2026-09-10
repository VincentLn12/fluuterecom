import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../controllers/navigation_controller.dart';
import '../../home/views/home_page.dart';
import '../../shops/views/shops_page.dart';
import '../../contents/views/contents_page.dart';
import '../../cart/views/cart_page.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../profile/views/profile_page.dart';

class MainPage extends GetView<NavigationController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.isRegistered<NavigationController>()
        ? Get.find<NavigationController>()
        : Get.put(NavigationController(), permanent: true);
    final cartController = Get.find<CartController>();
    final authService = Get.find<AuthService>();

    return Obx(() {
      final isLoggedIn = authService.isLoggedIn.value;

      final pages = [
        const HomePage(),
        const ShopsPage(),
        const ContentsPage(),
        if (isLoggedIn) const CartPage(),
        const ProfilePage(),
      ];

      final items = [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'หน้าแรก',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.storefront_outlined),
          activeIcon: Icon(Icons.storefront),
          label: 'ร้านค้า',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          activeIcon: Icon(Icons.article),
          label: 'เนื้อหา',
        ),
        if (isLoggedIn)
          BottomNavigationBarItem(
            icon: Obx(() {
              final count = cartController.totalItemCount;
              return Badge(
                isLabelVisible: count > 0,
                label: Text(
                  '$count',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                backgroundColor: const Color(0xFFD96C2C),
                child: const Icon(Icons.shopping_cart_outlined),
              );
            }),
            activeIcon: Obx(() {
              final count = cartController.totalItemCount;
              return Badge(
                isLabelVisible: count > 0,
                label: Text(
                  '$count',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                backgroundColor: const Color(0xFFD96C2C),
                child: const Icon(Icons.shopping_cart),
              );
            }),
            label: 'ตะกร้า',
          ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'โปรไฟล์',
        ),
      ];

      int currentIndex = navCtrl.selectedIndex.value;
      if (currentIndex >= items.length) {
        currentIndex = items.length - 1;
      }

      return Scaffold(
        body: IndexedStack(index: currentIndex, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            navCtrl.changeTab(index);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFD96C2C),
          unselectedItemColor: Colors.grey[600],
          items: items,
        ),
      );
    });
  }
}
