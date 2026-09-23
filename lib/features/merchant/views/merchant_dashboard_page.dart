import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/merchant_dashboard_controller.dart';
import '../models/merchant_dashboard_model.dart';

String formatCurrency(double amount) {
  final str = amount.toStringAsFixed(2);
  final parts = str.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
  return '฿$intPart';
}

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
                _buildShopHeaderCard(shop),
                const SizedBox(height: 16),

                // Inactive Shop Warning if applicable
                if (shop == null || shop.status != 'Active') ...[
                  _buildInactiveShopWarning(shop?.status),
                  const SizedBox(height: 16),
                ],

                // Order Processing Status Counters
                _buildOrderStatusCounters(report),
                const SizedBox(height: 20),

                // Revenue & Inventory Metrics Grid
                _buildMetricsGrid(report),
                const SizedBox(height: 20),

                _buildPromotionAnalytics(report),
                const SizedBox(height: 20),

                // Quick Navigation Actions
                _buildQuickActionsGrid(),
                const SizedBox(height: 20),

                // Recent Orders Section
                _buildRecentOrdersSection(report),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShopHeaderCard(dynamic shop) {
    final shopName = shop?.name ?? 'ยังไม่มีชื่อร้านค้า';
    final categoryName = shop?.categoryName ?? 'ผู้ประกอบการชุมชน';
    final districtName = shop?.districtName ?? 'กาญจนบุรี';
    final status = shop?.status ?? 'None';
    final coverImage = shop?.coverImageUrl ?? shop?.backgroundImageUrl;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF047857).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative ambient circles
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Shop Avatar Circle
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.6),
                          width: 2,
                        ),
                        image:
                            (coverImage != null &&
                                coverImage.toString().isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(coverImage.toString()),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child:
                          (coverImage == null || coverImage.toString().isEmpty)
                          ? const Icon(
                              Icons.storefront_rounded,
                              color: Colors.white,
                              size: 32,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  shopName,
                                  style: GoogleFonts.krub(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusPill(status),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: Color(0xFFA7F3D0),
                                size: 15,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '$categoryName • อ.$districtName',
                                  style: GoogleFonts.krub(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFD1FAE5),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            color: Color(0xFFA7F3D0),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'ระบบแดชบอร์ดร้านค้ากาญจนบุรี',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(AppRoutes.registerShop),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'แก้ไขร้านค้า',
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFA7F3D0),
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFFA7F3D0),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bg = const Color(0xFF64748B);
    String label = 'ยังไม่ลงทะเบียน';
    IconData icon = Icons.help_outline_rounded;

    if (status == 'Active') {
      bg = const Color(0xFF10B981);
      label = 'เปิดใช้งาน';
      icon = Icons.check_circle_rounded;
    } else if (status == 'PendingApproval') {
      bg = const Color(0xFFF59E0B);
      label = 'รออนุมัติ';
      icon = Icons.access_time_filled_rounded;
    } else if (status == 'Rejected') {
      bg = const Color(0xFFEF4444);
      label = 'ถูกปฏิเสธ';
      icon = Icons.cancel_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveShopWarning(String? status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE68A)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFD97706),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'แจ้งเตือนสถานะร้านค้า',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                    Text(
                      _getStatusDescription(status),
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.registerShop),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.edit_document, size: 18),
              label: Text(
                'ลงทะเบียน / แก้ไขข้อมูลร้านค้า',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusDescription(String? status) {
    if (status == 'PendingApproval') {
      return 'คำขอร้านค้าของคุณกำลังอยู่ระหว่างการตรวจสอบโดยผู้ดูแลระบบ';
    }
    if (status == 'Rejected') {
      return 'ร้านค้าของคุณยังไม่ได้รับการอนุมัติ กรุณาปรับปรุงข้อมูลตามคำแนะนำ';
    }
    if (status == 'Suspended') return 'ร้านค้าของคุณถูกระงับการใช้งานชั่วคราว';
    return 'ยังไม่มีข้อมูลร้านค้าในระบบ กรุณาลงทะเบียนร้านค้า';
  }

  Widget _buildOrderStatusCounters(MerchantDashboardModel? report) {
    final pendingSlip = report?.pendingSlipOrdersCount ?? 0;
    final pendingShipment = report?.pendingShipmentOrdersCount ?? 0;
    final completed = report?.completedOrdersCount ?? 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF047857),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'การประมวลผลคำสั่งซื้อ',
                    style: GoogleFonts.krub(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.myShopOrders),
                child: Text(
                  'ดูทั้งหมด >',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildCounterItem(
                  label: 'รอตรวจสลิป',
                  count: pendingSlip,
                  icon: Icons.receipt_long_rounded,
                  color: const Color(0xFFD97706),
                  bg: const Color(0xFFFFFBEB),
                  borderColor: const Color(0xFFFDE68A),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCounterItem(
                  label: 'รอจัดส่ง',
                  count: pendingShipment,
                  icon: Icons.local_shipping_rounded,
                  color: const Color(0xFF2563EB),
                  bg: const Color(0xFFEFF6FF),
                  borderColor: const Color(0xFFBFDBFE),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCounterItem(
                  label: 'สำเร็จแล้ว',
                  count: completed,
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF059669),
                  bg: const Color(0xFFECFDF5),
                  borderColor: const Color(0xFFA7F3D0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionAnalytics(MerchantDashboardModel? report) {
    final analytics = report?.promotionAnalytics ?? const PromotionAnalytics();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFBCFE8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFE11D48),
              ),
              const SizedBox(width: 8),
              Text(
                'วิเคราะห์โปรโมชัน',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _promotionMetric(
                  'ยอดขายจากโปร',
                  analytics.promotionRevenue,
                  Icons.payments_rounded,
                  const Color(0xFFBE123C),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _promotionMetric(
                  'ส่วนลดรวม',
                  analytics.totalDiscountAmount,
                  Icons.discount_rounded,
                  const Color(0xFFEA580C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _promotionMetric(
                  'ใช้สิทธิ์แล้ว',
                  analytics.usedQuantity.toDouble(),
                  Icons.shopping_bag_rounded,
                  const Color(0xFF7C3AED),
                  suffix: ' ชิ้น',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _promotionMetric(
                  'ดีลที่ใช้งาน',
                  analytics.activeDealsCount.toDouble(),
                  Icons.bolt_rounded,
                  const Color(0xFF0284C7),
                  suffix: ' ดีล',
                ),
              ),
            ],
          ),
          if (analytics.deals.isNotEmpty) ...[
            const Divider(height: 24),
            ...analytics.deals.map(
              (deal) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deal.productName,
                            style: GoogleFonts.krub(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${deal.dealTypeLabel} • ใช้แล้ว ${deal.usedQuantity}/${deal.totalQuantity} ชิ้น • ${deal.status}',
                            style: GoogleFonts.krub(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatCurrency(deal.revenue),
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFBE123C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _promotionMetric(
    String label,
    double value,
    IconData icon,
    Color color, {
    String suffix = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              '$label\n${formatCurrency(value)}$suffix',
              style: GoogleFonts.krub(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterItem({
    required String label,
    required int count,
    required IconData icon,
    required Color color,
    required Color bg,
    required Color borderColor,
  }) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.myShopOrders),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 6),
                Text(
                  '$count',
                  style: GoogleFonts.krub(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.krub(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF334155),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(MerchantDashboardModel? report) {
    final totalRev = report?.totalRevenue ?? 0.0;
    final monthRev = report?.monthRevenue ?? 0.0;
    final totalProd = report?.totalProducts ?? 0;
    final lowStock = report?.lowStockProductsCount ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'สรุปภาพรวมรายได้ & สต็อก',
              style: GoogleFonts.krub(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _buildStatCard(
              title: 'ยอดขายรวมทั้งหมด',
              value: formatCurrency(totalRev),
              icon: Icons.account_balance_wallet_rounded,
              color: const Color(0xFF059669),
              bg: const Color(0xFFECFDF5),
              borderColor: const Color(0xFFA7F3D0),
            ),
            _buildStatCard(
              title: 'ยอดขายเดือนนี้',
              value: formatCurrency(monthRev),
              icon: Icons.trending_up_rounded,
              color: const Color(0xFF0284C7),
              bg: const Color(0xFFF0F9FF),
              borderColor: const Color(0xFFBAE6FD),
            ),
            _buildStatCard(
              title: 'สินค้าในร้านทั้งหมด',
              value: '$totalProd รายการ',
              icon: Icons.inventory_2_rounded,
              color: const Color(0xFF7C3AED),
              bg: const Color(0xFFF5F3FF),
              borderColor: const Color(0xFFDDD6FE),
            ),
            _buildStatCard(
              title: 'สินค้าสต็อกต่ำ',
              value: '$lowStock รายการ',
              icon: Icons.warning_amber_rounded,
              color: lowStock > 0
                  ? const Color(0xFFE11D48)
                  : const Color(0xFF64748B),
              bg: lowStock > 0
                  ? const Color(0xFFFFF1F2)
                  : const Color(0xFFF8FAFC),
              borderColor: lowStock > 0
                  ? const Color(0xFFFECDD3)
                  : const Color(0xFFE2E8F0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bg,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.krub(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF9333EA),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'เมนูจัดการร้านค้า',
              style: GoogleFonts.krub(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _buildActionButton(
              title: 'จัดการสินค้า',
              subtitle: 'เพิ่ม/แก้ไขรายการสินค้า',
              icon: Icons.shopping_bag_rounded,
              color: const Color(0xFF059669),
              bg: const Color(0xFFECFDF5),
              onTap: () => Get.toNamed(AppRoutes.myShopProducts),
            ),
            _buildActionButton(
              title: 'จัดการคำสั่งซื้อ',
              subtitle: 'ตรวจสอบสลิป/แจ้งจัดส่ง',
              icon: Icons.assignment_rounded,
              color: const Color(0xFF2563EB),
              bg: const Color(0xFFEFF6FF),
              onTap: () => Get.toNamed(AppRoutes.myShopOrders),
            ),
            _buildActionButton(
              title: 'บทความร้านค้า',
              subtitle: 'โปรโมทร้าน/ข่าวสาร',
              icon: Icons.article_rounded,
              color: const Color(0xFF9333EA),
              bg: const Color(0xFFF5F3FF),
              onTap: () => Get.toNamed(AppRoutes.myShopContents),
            ),
            _buildActionButton(
              title: 'ส่งออกรายงาน',
              subtitle: 'รายงาน PDF & CSV',
              icon: Icons.download_rounded,
              color: const Color(0xFF047857),
              bg: const Color(0xFFECFDF5),
              onTap: () => Get.toNamed(AppRoutes.myShopExports),
            ),
            _buildActionButton(
              title: 'ข้อมูลร้านค้า',
              subtitle: 'แก้ไขที่อยู่/บัญชีธนาคาร',
              icon: Icons.storefront_rounded,
              color: const Color(0xFFD97706),
              bg: const Color(0xFFFFFBEB),
              onTap: () => Get.toNamed(AppRoutes.registerShop),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.krub(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentOrdersSection(MerchantDashboardModel? report) {
    final recentOrders = report?.recentOrders ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'คำสั่งซื้อล่าสุด',
                  style: GoogleFonts.krub(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.myShopOrders),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(
                'ดูทั้งหมด >',
                style: GoogleFonts.krub(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (recentOrders.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      size: 36,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ยังไม่มีรายการสั่งซื้อเข้ามาในระบบ',
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'เมื่อมีลูกค้าสั่งซื้อสินค้า รายการจะปรากฏตรงนี้',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentOrders.length > 5 ? 5 : recentOrders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = recentOrders[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ออเดอร์ #${item.orderNumber}',
                            style: GoogleFonts.krub(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ผู้ซื้อ: ${item.receiverName ?? 'ลูกค้าทั่วไป'}',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatCurrency(item.totalAmount),
                          style: GoogleFonts.krub(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildOrderStatusBadge(
                          item.orderStatus,
                          item.paymentStatus,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildOrderStatusBadge(String orderStatus, String paymentStatus) {
    Color bg = const Color(0xFFF1F5F9);
    Color fg = const Color(0xFF475569);
    String label = orderStatus;

    final payStat = paymentStatus.trim().toLowerCase();
    final orderStat = orderStatus.trim().toLowerCase();

    if (payStat == 'pendingverification') {
      bg = const Color(0xFFFFFBEB);
      fg = const Color(0xFFD97706);
      label = 'รอตรวจสลิป';
    } else if (orderStat == 'completed') {
      bg = const Color(0xFFECFDF5);
      fg = const Color(0xFF059669);
      label = 'สำเร็จ';
    } else if (orderStat == 'shipped') {
      bg = const Color(0xFFEEF2FF);
      fg = const Color(0xFF4F46E5);
      label = 'จัดส่งแล้ว';
    } else if (payStat == 'paid') {
      bg = const Color(0xFFEFF6FF);
      fg = const Color(0xFF2563EB);
      label = 'ชำระแล้ว';
    } else if (orderStat == 'cancelled') {
      bg = const Color(0xFFFFF1F2);
      fg = const Color(0xFFE11D48);
      label = 'ยกเลิก';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.krub(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }
}
