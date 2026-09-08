import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/status_badge.dart';
import '../models/order_model.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final OrderModel? order = args is OrderModel ? args : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'รายละเอียดคำสั่งซื้อ',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: order == null
          ? Center(
              child: Text(
                'ไม่พบข้อมูลคำสั่งซื้อ',
                style: GoogleFonts.krub(fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Header Banner Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF332820).withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.shopName ?? 'ร้านค้าชุมชน',
                              style: GoogleFonts.krub(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2B1F17),
                              ),
                            ),
                            StatusBadge(
                              label: order.statusLabel,
                              backgroundColor: const Color(0xFF1F5F58),
                            ),
                          ],
                        ),
                        const Divider(height: 20, color: Color(0xFFEADCCF)),
                        _buildRow('หมายเลขคำสั่งซื้อ', order.orderNumber ?? 'N/A'),
                        const SizedBox(height: 6),
                        if (order.createdAt != null)
                          _buildRow(
                            'วันที่สั่งซื้อ',
                            '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year} ${order.createdAt!.hour}:${order.createdAt!.minute.toString().padLeft(2, '0')} น.',
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Receiver & Address Card
                  Container(
                    padding: const EdgeInsets.all(20),
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
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: Color(0xFFD96C2C), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'ที่อยู่สำหรับจัดส่งสินค้า',
                              style: GoogleFonts.krub(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2B1F17),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20, color: Color(0xFFEADCCF)),
                        Text(
                          '${order.receiverName ?? "ผู้รับสินค้า"} (${order.receiverPhone ?? "N/A"})',
                          style: GoogleFonts.krub(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2B1F17),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.shippingAddress ?? 'ไม่ได้ระบุที่อยู่',
                          style: GoogleFonts.krub(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Order Items List Card
                  Container(
                    padding: const EdgeInsets.all(20),
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
                        Row(
                          children: [
                            const Icon(Icons.shopping_bag_rounded, color: Color(0xFF1F5F58), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'รายการสินค้าที่สั่งซื้อ',
                              style: GoogleFonts.krub(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2B1F17),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20, color: Color(0xFFEADCCF)),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order.items.length,
                          separatorBuilder: (context, i) => const Divider(height: 16, color: Color(0xFFF0E6DC)),
                          itemBuilder: (context, i) {
                            final item = order.items[i];
                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 54,
                                    height: 54,
                                    color: const Color(0xFFF7F0E6),
                                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                                        ? Image.network(
                                            item.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                                          )
                                        : const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
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
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2B1F17),
                                        ),
                                      ),
                                      Text(
                                        '฿${item.unitPrice.toStringAsFixed(2)} x ${item.quantity}',
                                        style: GoogleFonts.krub(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '฿${item.totalPrice.toStringAsFixed(2)}',
                                  style: GoogleFonts.krub(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFD96C2C),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Price Breakdown Summary
                  Container(
                    padding: const EdgeInsets.all(20),
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
                      children: [
                        _buildRow('ยอดรวมสินค้า', '฿${order.subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _buildRow('ค่าจัดส่ง (${order.shippingMethod ?? "Standard"})', '฿${order.shippingFee.toStringAsFixed(2)}'),
                        const Divider(height: 20, color: Color(0xFFEADCCF)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ยอดชำระสุทธิ',
                              style: GoogleFonts.krub(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2B1F17),
                              ),
                            ),
                            Text(
                              '฿${order.totalAmount.toStringAsFixed(2)}',
                              style: GoogleFonts.krub(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFD96C2C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.krub(fontSize: 14, color: Colors.grey[700])),
        Text(value, style: GoogleFonts.krub(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF2B1F17))),
      ],
    );
  }
}
