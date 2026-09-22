import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../models/admin_dashboard_model.dart';

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
                if (report != null) _buildAlertsBanner(context, report.alerts),

                const SizedBox(height: 16),

                // 2. Main KPI Statistics Grid
                _buildKpiGrid(report?.summary),

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
                _buildQuickAccessHub(context),

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
                  _buildOrderStatusBreakdown(report.orderStatusCounts),
                  const SizedBox(height: 20),
                ],

                // 5. Recent Orders & Top Shops Lists
                if (report != null) ...[
                  _buildRecentOrdersSection(report.recentOrders),
                  const SizedBox(height: 20),
                  _buildTopShopsSection(report.topShops),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAlertsBanner(BuildContext context, AdminDashboardAlerts alerts) {
    if (alerts.pendingSlips == 0 &&
        alerts.pendingPayoutOrders == 0 &&
        alerts.pendingShipmentOrders == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEEBA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFF856404)),
              const SizedBox(width: 8),
              Text(
                'รายการที่ต้องการการดำเนินการเร่งด่วน',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color(0xFF856404),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (alerts.pendingSlips > 0)
                ActionChip(
                  avatar: const Icon(Icons.receipt_long_outlined, size: 16, color: Colors.white),
                  label: Text('สลิปรอยืนยัน ${alerts.pendingSlips} รายการ'),
                  backgroundColor: AppColors.accent,
                  labelStyle: GoogleFonts.krub(color: Colors.white, fontSize: 12),
                  onPressed: () => Get.toNamed(AppRoutes.adminOrders),
                ),
              if (alerts.pendingPayoutOrders > 0)
                ActionChip(
                  avatar: const Icon(Icons.account_balance_wallet_outlined, size: 16, color: Colors.white),
                  label: Text('ร้านค้ารอโอนเงิน ${alerts.pendingPayoutOrders} รายการ'),
                  backgroundColor: AppColors.primary,
                  labelStyle: GoogleFonts.krub(color: Colors.white, fontSize: 12),
                  onPressed: () => Get.toNamed(AppRoutes.adminPayouts),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(AdminDashboardSummary? summary) {
    final totalSales = summary?.totalSales ?? 0.0;
    final totalOrders = summary?.totalOrders ?? 0;
    final paidOrders = summary?.paidOrders ?? 0;
    final pendingPayout = summary?.pendingPayoutAmount ?? 0.0;
    final activeShops = summary?.activeShops ?? 0;
    final lowStock = summary?.lowStockProducts ?? 0;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildKpiCard(
          title: 'ยอดขายรวม',
          value: '฿${totalSales.toStringAsFixed(2)}',
          icon: Icons.monetization_on_outlined,
          color: const Color(0xFF1B4D3E),
        ),
        _buildKpiCard(
          title: 'ออเดอร์ทั้งหมด',
          value: '$totalOrders รายการ',
          subtitle: 'ชำระแล้ว $paidOrders รายการ',
          icon: Icons.shopping_bag_outlined,
          color: const Color(0xFF2A9D8F),
        ),
        _buildKpiCard(
          title: 'ยอดรอโอนร้านค้า',
          value: '฿${pendingPayout.toStringAsFixed(2)}',
          icon: Icons.account_balance_outlined,
          color: AppColors.accent,
        ),
        _buildKpiCard(
          title: 'ร้านค้าที่เปิดใช้งาน',
          value: '$activeShops ร้าน',
          subtitle: lowStock > 0 ? 'สินค้าสต็อกต่ำ $lowStock รายการ' : null,
          icon: Icons.storefront_outlined,
          color: const Color(0xFF457B9D),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.krub(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickAccessHub(BuildContext context) {
    final items = [
      _QuickItem('1. รายงานผู้บริหาร', Icons.analytics_outlined, AppColors.primary, () => Get.toNamed(AppRoutes.adminExports)),
      _QuickItem('2. ตรวจสอบสลิป', Icons.fact_check_outlined, AppColors.accent, () => Get.toNamed(AppRoutes.adminOrders)),
      _QuickItem('3. โอนเงินร้านค้า', Icons.price_check_outlined, const Color(0xFF2A9D8F), () => Get.toNamed(AppRoutes.adminPayouts)),
      _QuickItem('4. จัดการร้านค้า', Icons.store_outlined, const Color(0xFF457B9D), () => Get.toNamed(AppRoutes.adminShops)),
      _QuickItem('5. จัดการหมวดหมู่', Icons.category_outlined, const Color(0xFFE9C46A), () => Get.toNamed(AppRoutes.adminCategories)),
      _QuickItem('6. จัดการเนื้อหา', Icons.article_outlined, const Color(0xFF6B705C), () => Get.toNamed(AppRoutes.adminContents)),
      _QuickItem('7. จัดการแท็ก', Icons.label_outlined, const Color(0xFF8338EC), () => Get.toNamed(AppRoutes.adminTags)),
      _QuickItem('8. ตารางกิจกรรม', Icons.event_outlined, const Color(0xFF3A86EF), () => Get.toNamed(AppRoutes.adminSchedules)),
      _QuickItem('9. รายงานร้องเรียน', Icons.report_problem_outlined, AppColors.error, () => Get.toNamed(AppRoutes.adminReports)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.color, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderStatusBreakdown(AdminOrderStatusCounts counts) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusColumn('รอชำระ', counts.pendingPayment, Colors.orange),
          _buildStatusColumn('รอยืนยัน', counts.pendingVerification, AppColors.accent),
          _buildStatusColumn('กำลังส่ง', counts.shipped, Colors.blue),
          _buildStatusColumn('สำเร็จ', counts.completed, AppColors.primary),
          _buildStatusColumn('ยกเลิก', counts.cancelled, Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatusColumn(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.krub(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRecentOrdersSection(List<AdminRecentOrder> recentOrders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'คำสั่งซื้อล่าสุด',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.adminOrders),
              child: Text(
                'ดูทั้งหมด',
                style: GoogleFonts.krub(color: AppColors.primary, fontSize: 13),
              ),
            ),
          ],
        ),
        if (recentOrders.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('ไม่มีคำสั่งซื้อล่าสุด')),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentOrders.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final order = recentOrders[index];
                return ListTile(
                  title: Text(
                    '#${order.orderNumber} - ${order.shopName}',
                    style: GoogleFonts.krub(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  subtitle: Text(
                    'ยอดรวม: ฿${order.totalAmount.toStringAsFixed(2)} | สถานะ: ${order.orderStatus}',
                    style: GoogleFonts.krub(fontSize: 11),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.paymentStatus,
                      style: GoogleFonts.krub(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildTopShopsSection(List<AdminTopShop> topShops) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ร้านค้ายอดขายสูงสุด',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        if (topShops.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('ไม่มีข้อมูลร้านค้า')),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topShops.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final shop = topShops[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.accent.withOpacity(0.15),
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.krub(fontWeight: FontWeight.bold, color: AppColors.accent),
                    ),
                  ),
                  title: Text(
                    shop.shopName,
                    style: GoogleFonts.krub(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: Text('ชำระแล้ว ${shop.paidOrders} ออเดอร์', style: GoogleFonts.krub(fontSize: 12)),
                  trailing: Text(
                    '฿${shop.sales.toStringAsFixed(2)}',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _showExportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ส่งออกรายงาน (Admin Exports)',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                title: Text('รายงานรายการสั่งซื้อ (Orders)', style: GoogleFonts.krub()),
                onTap: () {
                  Navigator.pop(context);
                  controller.exportData('orders');
                },
              ),
              ListTile(
                leading: const Icon(Icons.storefront_outlined, color: AppColors.accent),
                title: Text('รายงานยอดขายตามร้านค้า (Shop Sales)', style: GoogleFonts.krub()),
                onTap: () {
                  Navigator.pop(context);
                  controller.exportData('shop-sales');
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF2A9D8F)),
                title: Text('รายงานประวัติการโอนเงิน (Payouts)', style: GoogleFonts.krub()),
                onTap: () {
                  Navigator.pop(context);
                  controller.exportData('payouts');
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined, color: Color(0xFF457B9D)),
                title: Text('รายงานการตรวจสอบสลิป (Payment Slips)', style: GoogleFonts.krub()),
                onTap: () {
                  Navigator.pop(context);
                  controller.exportData('payment-slips');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickItem(this.title, this.icon, this.color, this.onTap);
}
