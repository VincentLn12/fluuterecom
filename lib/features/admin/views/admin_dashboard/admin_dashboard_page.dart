import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../controllers/admin_dashboard_controller.dart';
import 'widgets/admin_dashboard_alerts_banner.dart';
import 'widgets/admin_dashboard_kpi_grid.dart';
import 'widgets/admin_dashboard_quick_access_hub.dart';
import 'widgets/admin_dashboard_order_status_breakdown.dart';
import 'widgets/admin_dashboard_recent_orders.dart';
import 'widgets/admin_dashboard_top_shops.dart';

class AdminDashboardPage extends GetView<AdminDashboardController> {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminDashboardController>()) {
      Get.put(AdminDashboardController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ระบบผู้ดูแลระบบ (Admin Dashboard)',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'รีเฟรชข้อมูล',
            onPressed: () => controller.loadDashboard(),
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.white),
            tooltip: 'ส่งออกรายงาน (Exports)',
            onPressed: () => Get.toNamed(AppRoutes.adminExports),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.loadDashboard(),
        color: AppColors.primary,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final report = controller.report.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Alert Banner Section
                if (report != null)
                  AdminDashboardAlertsBanner(alerts: report.alerts),

                const SizedBox(height: 16),

                // 2. Main KPI Statistics Grid
                AdminDashboardKpiGrid(summary: report?.summary),

                const SizedBox(height: 20),

                // 3. Sub-systems Quick Access Grid (13 Systems Hub)
                Text(
                  'ระบบย่อยสำหรับผู้ดูแลระบบ',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const AdminDashboardQuickAccessHub(),

                const SizedBox(height: 20),

                // 4. Order Status Counter Breakdown
                if (report != null) ...[
                  Text(
                    'สรุปสถานะคำสั่งซื้อ',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AdminDashboardOrderStatusBreakdown(
                    counts: report.orderStatusCounts,
                  ),
                  const SizedBox(height: 20),
                ],

                // 5. Recent Orders & Top Shops Lists
                if (report != null) ...[
                  AdminDashboardRecentOrders(recentOrders: report.recentOrders),
                  const SizedBox(height: 20),
                  AdminDashboardTopShops(topShops: report.topShops),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
