import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../bills/bill_list_view.dart';
import '../dashboard/dashboard_view.dart';
import '../maintenance/maintenance_view.dart';
import '../rooms/room_list_view.dart';
import '../tenants/tenant_detail_view.dart';
import '../tenants/tenant_home_view.dart';
import '../tenants/tenant_list_view.dart';
import 'more_view.dart';

class MainNavigationView extends GetView<NavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      final isOwner = authController.isOwner;
      final pages = isOwner
          ? [
              const DashboardView(),
              const RoomListView(),
              const TenantListView(),
              BillListView(),
              const MoreView(),
            ]
          : [
              const TenantHomeView(),
              BillListView(),
              const MaintenanceView(isTenantMode: true),
              TenantDetailView(
                tenantId: authController.currentUser.value?.tenantId,
              ),
            ];

      final destinations = isOwner
          ? const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'หน้าหลัก',
              ),
              NavigationDestination(
                icon: Icon(Icons.meeting_room_outlined),
                selectedIcon: Icon(Icons.meeting_room),
                label: 'ห้องพัก',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: 'ผู้เช่า',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'บิล',
              ),
              NavigationDestination(
                icon: Icon(Icons.more_horiz),
                selectedIcon: Icon(Icons.more_horiz),
                label: 'เพิ่มเติม',
              ),
            ]
          : const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'หน้าหลัก',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'บิล',
              ),
              NavigationDestination(
                icon: Icon(Icons.build_circle_outlined),
                selectedIcon: Icon(Icons.build_circle),
                label: 'แจ้งซ่อม',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'โปรไฟล์',
              ),
            ];

      final selectedIndex = controller.selectedIndex.value >= pages.length
          ? 0
          : controller.selectedIndex.value;

      return Scaffold(
        body: IndexedStack(index: selectedIndex, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: controller.changePage,
          destinations: destinations,
        ),
      );
    });
  }
}
