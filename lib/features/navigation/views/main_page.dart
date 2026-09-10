import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../contents/views/contents_page.dart';
import '../../home/views/home_page.dart';
import '../../profile/views/profile_page.dart';
import '../../shops/views/shops_page.dart';
import '../../cart/views/cart_page.dart';
import '../controllers/navigation_controller.dart';

class MainPage extends GetView<NavigationController> {
  const MainPage({super.key});

  static const Color brandPrimary = Color(0xFFC85A17);
  static const Color navBg = Colors.white;
  static const Color textActive = Color(0xFFC85A17);
  static const Color textInactive = Color(0xFF64748B);

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

      int currentIndex = navCtrl.selectedIndex.value;
      if (currentIndex >= pages.length) {
        currentIndex = pages.length - 1;
      }

      return Scaffold(
        body: IndexedStack(index: currentIndex, children: pages),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: navBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 68,
              child: Row(
                children: [
                  // Tab 0: Home
                  Expanded(
                    child: _buildNavItem(
                      index: 0,
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'หน้าแรก',
                      navCtrl: navCtrl,
                    ),
                  ),

                  // Tab 1: Shops
                  Expanded(
                    child: _buildNavItem(
                      index: 1,
                      icon: Icons.storefront_outlined,
                      activeIcon: Icons.storefront_rounded,
                      label: 'ร้านค้า',
                      navCtrl: navCtrl,
                    ),
                  ),

                  // CENTER RAISED '+' BUTTON (Create Content)
                  Expanded(child: _buildCenterPlusButton(context)),

                  // Tab 2: Contents
                  Expanded(
                    child: _buildNavItem(
                      index: 2,
                      icon: Icons.article_outlined,
                      activeIcon: Icons.article_rounded,
                      label: 'เนื้อหา',
                      navCtrl: navCtrl,
                    ),
                  ),

                  // Tab 3 / 4: Cart or Profile
                  if (isLoggedIn)
                    Expanded(
                      child: _buildCartNavItem(
                        index: 3,
                        cartController: cartController,
                        navCtrl: navCtrl,
                      ),
                    ),

                  // Profile Tab
                  Expanded(
                    child: _buildNavItem(
                      index: isLoggedIn ? 4 : 3,
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'โปรไฟล์',
                      navCtrl: navCtrl,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ==========================================
  // CENTER RAISED '+' FAB BUTTON
  // ==========================================
  Widget _buildCenterPlusButton(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -12),
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.createContent),
        borderRadius: BorderRadius.circular(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC85A17), Color(0xFFFF7043)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: brandPrimary.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 1),
            const Text(
              'ลงคอนเทนต์',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: brandPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // NAV TAB ITEM
  // ==========================================
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required NavigationController navCtrl,
  }) {
    final isSelected = navCtrl.selectedIndex.value == index;

    return InkWell(
      onTap: () => navCtrl.changeTab(index),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? brandPrimary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? textActive : textInactive,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? textActive : textInactive,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // CART NAV TAB ITEM WITH BADGE
  // ==========================================
  Widget _buildCartNavItem({
    required int index,
    required CartController cartController,
    required NavigationController navCtrl,
  }) {
    final isSelected = navCtrl.selectedIndex.value == index;

    return InkWell(
      onTap: () => navCtrl.changeTab(index),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              final count = cartController.totalItemCount;
              return Badge(
                isLabelVisible: count > 0,
                label: Text(
                  '$count',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 9.5,
                  ),
                ),
                backgroundColor: brandPrimary,
                child: Icon(
                  isSelected
                      ? Icons.shopping_cart_rounded
                      : Icons.shopping_cart_outlined,
                  color: isSelected ? textActive : textInactive,
                  size: 22,
                ),
              );
            }),
            const SizedBox(height: 2),
            Text(
              'ตะกร้า',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected ? textActive : textInactive,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
