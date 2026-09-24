import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'package:projecte/features/merchant/controllers/merchant_dashboard_controller.dart';
import 'package:projecte/features/merchant/views/merchant_dashboard/widgets/merchant_dashboard_shop_header.dart';
import 'package:projecte/features/merchant/views/merchant_dashboard/widgets/merchant_dashboard_shop_warning.dart';
import 'package:projecte/features/merchant/views/merchant_dashboard/widgets/merchant_dashboard_order_counters.dart';
import 'package:projecte/features/merchant/views/merchant_dashboard/widgets/merchant_dashboard_promotion_analytics.dart';
import 'package:projecte/features/merchant/views/merchant_dashboard/widgets/merchant_dashboard_metrics.dart';
import 'package:projecte/features/merchant/views/merchant_dashboard/widgets/merchant_dashboard_quick_actions.dart';
import 'package:projecte/features/merchant/views/merchant_dashboard/widgets/merchant_dashboard_recent_orders.dart';

class MerchantDashboardPage extends GetView<MerchantDashboardController> {
  const MerchantDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.dashboard_rounded,
                color: Color(0xFF047857),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'จัดการร้านค้า',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Merchant Dashboard Overview',
                    style: GoogleFonts.krub(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Obx(() {
            return Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: IconButton(
                icon: controller.isRefreshing.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF047857),
                        ),
                      )
                    : const Icon(
                        Icons.refresh_rounded,
                        color: Color(0xFF047857),
                        size: 22,
                      ),
                onPressed: controller.isRefreshing.value
                    ? null
                    : () => controller.refreshData(),
                tooltip: 'รีเฟรชข้อมูล',
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(
            message: 'กำลังโหลดข้อมูลแดชบอร์ดร้านค้า...',
          );
        }

        final shop = controller.myShop.value;
        final report = controller.report.value;

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: const Color(0xFF047857),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Shop Header Hero Card
                MerchantDashboardShopHeader(shop: shop),
                const SizedBox(height: 16),

                // Inactive Shop Warning if applicable
                if (shop == null || shop.status != 'Active') ...[
                  MerchantDashboardShopWarning(status: shop?.status),
                  const SizedBox(height: 16),
                ],

                // Order Processing Status Counters
                MerchantDashboardOrderCounters(report: report),
                const SizedBox(height: 20),

                // Revenue & Inventory Metrics Grid
                MerchantDashboardMetrics(report: report),
                const SizedBox(height: 20),

                MerchantDashboardPromotionAnalytics(report: report),
                const SizedBox(height: 20),

                // Quick Navigation Actions
                const MerchantDashboardQuickActions(),
                const SizedBox(height: 20),

                // Recent Orders Section
                MerchantDashboardRecentOrders(report: report),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }
}
