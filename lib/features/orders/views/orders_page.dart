import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/empty_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/order_controller.dart';
import '../models/order_model.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusTabs = [
      {'id': 0, 'label': 'ทั้งหมด'},
      {'id': 1, 'label': 'ที่ต้องชำระ'},
      {'id': 2, 'label': 'ที่ต้องจัดส่ง'},
      {'id': 3, 'label': 'ที่ต้องได้รับ'},
      {'id': 4, 'label': 'สำเร็จแล้ว'},
      {'id': 5, 'label': 'ยกเลิกแล้ว'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'คำสั่งซื้อของฉัน',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Get.back();
            } else {
              Get.offAllNamed(AppRoutes.initial);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            tooltip: 'กลับสู่หน้าหลัก',
            onPressed: () {
              Get.offAllNamed(AppRoutes.initial);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Shopee-style Horizontal Tab Filter Bar
          Container(
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5ECE8), width: 1),
              ),
            ),
            child: Obx(
              () {
                final currentTab = controller.activeTab.value;
                final orderCount = controller.orders.length;

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: statusTabs.length + (orderCount * 0),
                  separatorBuilder: (context, index) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final tab = statusTabs[index];
                    final tabId = tab['id'] as int;
                    final isSelected = currentTab == tabId;
                    final count = controller.getCountByTab(tabId);

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => controller.setActiveTab(tabId),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tab['label'] as String,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFFD96C2C)
                                      : const Color(0xFF6B8E85),
                                ),
                              ),
                              if (count > 0 && tabId != 0) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFD96C2C)
                                        : const Color(0xFFEEF4F1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$count',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF5A7B70),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          // Active Underline Indicator Bar
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            height: 3,
                            width: isSelected ? 32 : 0,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFD96C2C)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Main Orders List
          Expanded(
            child: Obx(() {
              final isLoading = controller.isLoading.value;
              final filteredList = controller.filteredOrders;

              if (isLoading) {
                return const LoadingWidget(message: 'กำลังโหลดรายการคำสั่งซื้อ...');
              }

              if (filteredList.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.loadOrders,
                  color: const Color(0xFFD96C2C),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 80),
                      EmptyWidget(
                        title: 'ยังไม่มีคำสั่งซื้อในหมวดหมู่นี้',
                        message: 'รายการคำสั่งซื้อของคุณจะปรากฏที่นี่เมื่อมีสถานะตรงกัน',
                        icon: Icons.receipt_long_outlined,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadOrders,
                color: const Color(0xFFD96C2C),
                child: ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final order = filteredList[index];
                    return _buildShopeeOrderCard(context, order);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShopeeOrderCard(BuildContext context, OrderModel order) {
    Color statusColor;
    switch (order.orderStatus.toLowerCase()) {
      case 'pending':
        statusColor = const Color(0xFFE76F51);
        break;
      case 'paid':
      case 'processing':
        statusColor = const Color(0xFF2A9D8F);
        break;
      case 'shipped':
        statusColor = const Color(0xFF2980B9);
        break;
      case 'completed':
        statusColor = const Color(0xFF2E7D32);
        break;
      case 'cancelled':
        statusColor = Colors.grey[600]!;
        break;
      default:
        statusColor = const Color(0xFFD96C2C);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0EAE6), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Shop Name & Status
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.storefront_rounded,
                        size: 18,
                        color: Color(0xFF0D2B22),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          order.shopName ?? 'ร้านค้าชุมชน',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D2B22),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  order.statusLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEF4F1)),

          // Product Items List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 58,
                          height: 58,
                          color: const Color(0xFFF4F6F5),
                          child: item.imageUrl != null &&
                                  item.imageUrl!.isNotEmpty
                              ? Image.network(
                                  item.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.grey,
                                  ),
                                )
                              : const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.grey,
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
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D2B22),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'x${item.quantity}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '฿${item.unitPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D2B22),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEF4F1)),

          // Order Total Summary Row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'รวม ${order.items.length} รายการ',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'ยอดคำสั่งซื้อทั้งหมด: ',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF0D2B22),
                      ),
                    ),
                    Text(
                      '฿${order.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFD96C2C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEF4F1)),

          // Bottom Action Buttons Row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.orderDetail, arguments: order);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0D2B22),
                    side: const BorderSide(color: Color(0xFFC0D4CD), width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text(
                    'ดูรายละเอียด',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
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
}
