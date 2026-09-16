import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/merchant_dashboard_controller.dart';

String formatCurrency(double amount) {
  final str = amount.toStringAsFixed(2);
  final parts = str.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
  return intPart;
}

class MerchantDashboardPage extends GetView<MerchantDashboardController> {
  const MerchantDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(
          'จัดการร้านค้า (Merchant Dashboard)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.refreshData(),
            tooltip: 'รีเฟรชข้อมูล',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดข้อมูลร้านค้า...');
        }

        final shop = controller.myShop.value;
        final report = controller.report.value;

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: const Color(0xFF047857),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildShopHeaderCard(shop),
                const SizedBox(height: 20),

                if (shop == null || shop.status != 'Active') ...[
                  _buildInactiveShopWarning(shop?.status),
                  const SizedBox(height: 20),
                ],

                // Quick Navigation Actions (เลือกเมนูจัดการ)
                _buildQuickActionsGrid(),
                const SizedBox(height: 24),

                // Metrics Grid (สรุปภาพรวม)
                _buildMetricsGrid(report),
                const SizedBox(height: 24),

                // Recent Orders Section
                _buildRecentOrdersSection(report),
                const SizedBox(height: 36),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShopHeaderCard(dynamic shop) {
    final shopName = shop?.name ?? 'ยังไม่มีร้านค้า';
    final categoryName = shop?.categoryName ?? 'ผู้ประกอบการ';
    final districtName = shop?.districtName ?? 'กาญจนบุรี';
    final status = shop?.status ?? 'None';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF047857).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 32,
            ),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusPill(status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$categoryName • อ.$districtName',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
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

    if (status == 'Active') {
      bg = const Color(0xFF10B981);
      label = 'เปิดใช้งาน';
    } else if (status == 'PendingApproval') {
      bg = const Color(0xFFF59E0B);
      label = 'รออนุมัติ';
    } else if (status == 'Rejected') {
      bg = const Color(0xFFEF4444);
      label = 'ถูกปฏิเสธ';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: GoogleFonts.krub(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInactiveShopWarning(String? status) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706)),
              const SizedBox(width: 10),
              Text(
                'สถานะร้านค้าของคุณ: ${_getStatusDescription(status)}',
                style: GoogleFonts.krub(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.registerShop),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.edit_document, size: 18),
            label: Text(
              'ดูข้อมูลใบสมัคร / แก้ไขข้อมูลร้านค้า',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusDescription(String? status) {
    if (status == 'PendingApproval') return 'รอแอดมินอนุมัติ';
    if (status == 'Rejected') return 'ยังไม่ได้รับการอนุมัติ';
    if (status == 'Suspended') return 'ถูกระงับการใช้งาน';
    return 'ยังไม่มีร้านค้า';
  }

  Widget _buildMetricsGrid(dynamic report) {
    final totalRev = report?.totalRevenue ?? 0.0;
    final monthRev = report?.monthRevenue ?? 0.0;
    final totalProd = report?.totalProducts ?? 0;
    final lowStock = report?.lowStockProductsCount ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'สรุปภาพรวมร้านค้า',
          style: GoogleFonts.krub(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.4,
          children: [
            _buildStatCard(
              title: 'ยอดขายรวมทั้งหมด',
              value: '฿${formatCurrency(totalRev)}',
              icon: Icons.account_balance_wallet_rounded,
              color: const Color(0xFF059669),
              bg: const Color(0xFFECFDF5),
            ),
            _buildStatCard(
              title: 'ยอดขายเดือนนี้',
              value: '฿${formatCurrency(monthRev)}',
              icon: Icons.trending_up_rounded,
              color: const Color(0xFF0284C7),
              bg: const Color(0xFFF0F9FF),
            ),
            _buildStatCard(
              title: 'สินค้าทั้งหมด',
              value: '$totalProd รายการ',
              icon: Icons.inventory_2_rounded,
              color: const Color(0xFF7C3AED),
              bg: const Color(0xFFF5F3FF),
            ),
            _buildStatCard(
              title: 'สินค้าสต็อกต่ำ',
              value: '$lowStock รายการ',
              icon: Icons.warning_amber_rounded,
              color: lowStock > 0 ? const Color(0xFFE11D48) : const Color(0xFF64748B),
              bg: lowStock > 0 ? const Color(0xFFFFE4E6) : const Color(0xFFF1F5F9),
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
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
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
        Text(
          'เมนูจัดการร้านค้า',
          style: GoogleFonts.krub(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
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
            _buildActionButton(
              title: 'จัดการสินค้า',
              subtitle: 'เพิ่ม/แก้ไข/ตั้งราคา',
              icon: Icons.shopping_bag_outlined,
              color: const Color(0xFF059669),
              onTap: () => Get.toNamed(AppRoutes.myShopProducts),
            ),
            _buildActionButton(
              title: 'จัดการคำสั่งซื้อ',
              subtitle: 'ตรวจสอบ/จัดส่งพัสดุ',
              icon: Icons.assignment_outlined,
              color: const Color(0xFF2563EB),
              onTap: () => Get.toNamed(AppRoutes.myShopOrders),
            ),
            _buildActionButton(
              title: 'บทความร้านค้า',
              subtitle: 'โพสต์โปรโมทร้านค้า',
              icon: Icons.article_outlined,
              color: const Color(0xFF9333EA),
              onTap: () => Get.toNamed(AppRoutes.myShopContents),
            ),
            _buildActionButton(
              title: 'ส่งออกรายงาน',
              subtitle: 'ดาวน์โหลด PDF/CSV',
              icon: Icons.download_rounded,
              color: const Color(0xFF047857),
              onTap: () => Get.toNamed(AppRoutes.myShopExports),
            ),
            _buildActionButton(
              title: 'ข้อมูลร้านค้า',
              subtitle: 'แก้ไขที่อยู่/ธนาคาร',
              icon: Icons.settings_outlined,
              color: const Color(0xFFD97706),
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
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 8),
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

  Widget _buildRecentOrdersSection(dynamic report) {
    final recentOrders = report?.recentOrders as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'คำสั่งซื้อล่าสุด',
              style: GoogleFonts.krub(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.myShopOrders),
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
        const SizedBox(height: 8),
        if (recentOrders.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(
              child: Text(
                'ยังไม่มีรายการสั่งซื้อเข้ามาในระบบ',
                style: GoogleFonts.krub(color: const Color(0xFF94A3B8)),
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
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(12),
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
                            'ผู้ซื้อ: ${item.receiverName ?? 'ลูกค้า'}',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '฿${formatCurrency(item.totalAmount)}',
                          style: GoogleFonts.krub(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.orderStatus,
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
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
}
