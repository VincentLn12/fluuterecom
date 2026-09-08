import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/empty_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/status_badge.dart';
import '../controllers/order_controller.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ประวัติคำสั่งซื้อของฉัน',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดรายการคำสั่งซื้อ...');
        }

        if (controller.orders.isEmpty) {
          return const EmptyWidget(
            title: 'ยังไม่มีประวัติคำสั่งซื้อ',
            message: 'รายการคำสั่งซื้อของคุณจะปรากฏที่นี่เมื่อสั่งซื้อสินค้า',
            icon: Icons.receipt_long_outlined,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadOrders,
          color: const Color(0xFFD96C2C),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF332820).withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Status & Order Number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.storefront_rounded, size: 18, color: Color(0xFF1F5F58)),
                            const SizedBox(width: 6),
                            Text(
                              order.shopName ?? 'ร้านค้าชุมชน',
                              style: GoogleFonts.krub(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2B1F17),
                              ),
                            ),
                          ],
                        ),
                        StatusBadge(
                          label: order.statusLabel,
                          backgroundColor: const Color(0xFF1F5F58),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: Color(0xFFEADCCF)),

                    Text(
                      'หมายเลขสั่งซื้อ: ${order.orderNumber}',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 6),

                    if (order.items.isNotEmpty) ...[
                      Text(
                        '${order.items.first.productName} ${order.items.length > 1 ? "และสินค้าอื่นอีก ${order.items.length - 1} รายการ" : ""}',
                        style: GoogleFonts.krub(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2B1F17),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ยอดชำระสุทธิ:',
                          style: GoogleFonts.krub(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '฿${order.totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.krub(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD96C2C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.orderDetail, arguments: order);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD96C2C),
                          side: const BorderSide(color: Color(0xFFD96C2C), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'ดูรายละเอียดคำสั่งซื้อ',
                          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
