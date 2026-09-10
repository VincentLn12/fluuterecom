import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';

import '../../../shared/widgets/loading_widget.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusTabs = [
      {'id': 0, 'label': 'ทั้งหมด', 'icon': Icons.all_inbox_rounded},
      {
        'id': 1,
        'label': 'ที่ต้องชำระ',
        'icon': Icons.account_balance_wallet_outlined,
      },
      {'id': 2, 'label': 'ที่ต้องจัดส่ง', 'icon': Icons.inventory_2_outlined},
      {
        'id': 3,
        'label': 'ที่ต้องได้รับ',
        'icon': Icons.local_shipping_outlined,
      },
      {
        'id': 4,
        'label': 'สำเร็จแล้ว',
        'icon': Icons.check_circle_outline_rounded,
      },
      {'id': 5, 'label': 'ยกเลิกแล้ว', 'icon': Icons.cancel_outlined},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Get.back();
            } else {
              Get.offAllNamed(AppRoutes.initial);
            }
          },
        ),
        title: Text(
          'คำสั่งซื้อของฉัน',
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
            onPressed: () => controller.loadOrders(),
          ),
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            tooltip: 'กลับสู่หน้าหลัก',
            onPressed: () => Get.offAllNamed(AppRoutes.initial),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Horizontal Status Tabs Filter Bar
          _buildFilterTabBar(statusTabs),

          // 2. Main Content View
          Expanded(
            child: Obx(() {
              final isLoading = controller.isLoading.value;
              final filteredList = controller.filteredOrders;

              if (isLoading) {
                return const LoadingWidget(
                  message: 'กำลังโหลดคำสั่งซื้อของคุณ...',
                  icon: Icons.receipt_long_rounded,
                );
              }

              if (filteredList.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: controller.loadOrders,
                color: const Color(0xFFD96C2C),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  itemCount: filteredList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final order = filteredList[index];
                    return _buildOrderCard(context, order);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabBar(List<Map<String, dynamic>> statusTabs) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF9F2),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8D9C9), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final currentTab = controller.activeTab.value;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: statusTabs.map((tab) {
              final tabId = tab['id'] as int;
              final isSelected = currentTab == tabId;
              final count = controller.getCountByTab(tabId);
              final iconData = tab['icon'] as IconData;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => controller.setActiveTab(tabId),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFD96C2C)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFD96C2C)
                            : const Color(0xFFE8D9C9),
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFFD96C2C,
                                ).withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          iconData,
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF786B62),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tab['label'] as String,
                          style: GoogleFonts.krub(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF332820),
                          ),
                        ),
                        if (count > 0 && tabId != 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : const Color(
                                      0xFFD96C2C,
                                    ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$count',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFFD96C2C),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final statusConfig = _getStatusConfig(order.orderStatus);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Shop Info & Status Badge
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    size: 18,
                    color: Color(0xFFD96C2C),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    order.shopName ?? 'ร้านค้าชุมชนกาญจนบุรี',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF332820),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Status Badge Chip
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusConfig.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusConfig.icon, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            order.statusLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.krub(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE8D9C9)),

          // 2. Order Number & Date Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'หมายเลข: #${order.orderNumber ?? order.id}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: const Color(0xFF786B62),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (order.createdAt != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(order.createdAt!),
                    style: GoogleFonts.krub(
                      fontSize: 11.5,
                      color: const Color(0xFF786B62),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE8D9C9)),

          // 3. Products List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 54,
                          height: 54,
                          color: const Color(0xFFE8D9C9).withValues(alpha: 0.3),
                          child:
                              item.imageUrl != null && item.imageUrl!.isNotEmpty
                              ? Image.network(
                                  item.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Color(0xFF786B62),
                                        size: 24,
                                      ),
                                )
                              : const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Color(0xFF786B62),
                                  size: 24,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.krub(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF332820),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'จำนวน: ${item.quantity} ชิ้น',
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                color: const Color(0xFF786B62),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '฿${item.unitPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.krub(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF332820),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE8D9C9)),

          // 4. Order Total Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'รวม ${order.items.length} รายการ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 12.5,
                      color: const Color(0xFF786B62),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ยอดรวมสุทธิ: ',
                      style: GoogleFonts.krub(
                        fontSize: 13.5,
                        color: const Color(0xFF332820),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '฿${order.totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.krub(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFD96C2C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE8D9C9)),

          // 5. Action Buttons Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (order.orderStatus.toLowerCase() == 'pending') ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(AppRoutes.payment, arguments: order);
                    },
                    icon: const Icon(Icons.payment_rounded, size: 16),
                    label: Text(
                      'ชำระเงิน',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD96C2C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                    ),
                  ),
                ],

                OutlinedButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.orderDetail, arguments: order);
                  },
                  icon: const Icon(Icons.receipt_long_outlined, size: 16),
                  label: Text(
                    'ดูรายละเอียด',
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF332820),
                    side: const BorderSide(
                      color: Color(0xFFE8D9C9),
                      width: 1.2,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.loadOrders,
      color: const Color(0xFFD96C2C),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 50),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    size: 48,
                    color: Color(0xFFD96C2C),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'ยังไม่มีคำสั่งซื้อในหมวดหมู่นี้',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: const Color(0xFF332820),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'รายการคำสั่งซื้อสินค้าโอทอปและสินค้าชุมชนของคุณจะปรากฏที่นี่เมื่อมีคำสั่งซื้อตรงตามสถานะ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: const Color(0xFF786B62),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed(AppRoutes.initial),
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: Text(
                    'เลือกซื้อสินค้าชุมชน',
                    style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD96C2C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return _StatusConfig(
          bg: const Color(0xFFE76F51),
          icon: Icons.hourglass_empty_rounded,
        );
      case 'paid':
      case 'processing':
        return _StatusConfig(
          bg: const Color(0xFF2A9D8F),
          icon: Icons.inventory_2_outlined,
        );
      case 'shipped':
        return _StatusConfig(
          bg: const Color(0xFF2980B9),
          icon: Icons.local_shipping_outlined,
        );
      case 'completed':
        return _StatusConfig(
          bg: const Color(0xFF059669),
          icon: Icons.check_circle_outline_rounded,
        );
      case 'cancelled':
        return _StatusConfig(
          bg: const Color(0xFF786B62),
          icon: Icons.cancel_outlined,
        );
      default:
        return _StatusConfig(
          bg: const Color(0xFFD96C2C),
          icon: Icons.info_outline_rounded,
        );
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];
    final monthName = months[dt.month - 1];
    final yearThai = dt.year + 543;
    final minuteStr = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} $monthName $yearThai - ${dt.hour}:$minuteStr น.';
  }
}

class _StatusConfig {
  final Color bg;
  final IconData icon;

  _StatusConfig({required this.bg, required this.icon});
}
