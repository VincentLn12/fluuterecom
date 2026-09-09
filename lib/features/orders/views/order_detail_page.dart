import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
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
      body: order == null
          ? Center(
              child: Text(
                'ไม่พบข้อมูลคำสั่งซื้อ',
                style: GoogleFonts.krub(fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Status Banner Header Box
                  _buildStatusBanner(context, order),

                  const SizedBox(height: 12),

                  // 2. Shipping Address Card
                  _buildShippingAddressCard(order),

                  const SizedBox(height: 12),

                  // 3. Shop & Ordered Items Card
                  _buildShopAndItemsCard(context, order),

                  const SizedBox(height: 12),

                  // 4. Payment & Price Breakdown Card
                  _buildPaymentSummaryCard(context, order),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusBanner(BuildContext context, OrderModel order) {
    Color bannerBg;
    IconData bannerIcon;
    String statusDesc;

    switch (order.orderStatus.toLowerCase()) {
      case 'pending':
        bannerBg = const Color(0xFFD96C2C);
        bannerIcon = Icons.access_time_filled_rounded;
        statusDesc = 'กรุณาชำระเงินเพื่อดำเนินการต่อในขั้นตอนถัดไป';
        break;
      case 'paid':
      case 'processing':
        bannerBg = const Color(0xFF2A9D8F);
        bannerIcon = Icons.inventory_2_rounded;
        statusDesc = 'ผู้ขายกำลังจัดเตรียมสินค้าของคุณเพื่อการจัดส่ง';
        break;
      case 'shipped':
        bannerBg = const Color(0xFF2980B9);
        bannerIcon = Icons.local_shipping_rounded;
        statusDesc = 'พัสดุของคุณอยู่ระหว่างการจัดส่งไปยังที่อยู่ระบุ';
        break;
      case 'completed':
        bannerBg = const Color(0xFF2E7D32);
        bannerIcon = Icons.check_circle_rounded;
        statusDesc = 'คำสั่งซื้อสำเร็จ ขอบคุณที่ร่วมอุดหนุนสินค้าโอทอปกาญจนบุรี';
        break;
      case 'cancelled':
        bannerBg = Colors.grey[700]!;
        bannerIcon = Icons.cancel_rounded;
        statusDesc = 'คำสั่งซื้อนี้ถูกยกเลิกเรียบร้อยแล้ว';
        break;
      default:
        bannerBg = const Color(0xFF2A9D8F);
        bannerIcon = Icons.info_rounded;
        statusDesc = 'สถานะคำสั่งซื้อปัจจุบันของคุณ';
    }

    final dateStr = order.createdAt != null
        ? '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year} ${order.createdAt!.hour}:${order.createdAt!.minute.toString().padLeft(2, '0')} น.'
        : '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bannerBg.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.statusLabel,
                  style: GoogleFonts.krub(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusDesc,
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'สั่งซื้อเมื่อ: $dateStr',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(bannerIcon, size: 48, color: Colors.white.withValues(alpha: 0.9)),
        ],
      ),
    );
  }

  Widget _buildShippingAddressCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0EAE6), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
                  color: const Color(0xFF0D2B22),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFEEF4F1)),
          Text(
            '${order.receiverName ?? "ผู้รับสินค้า"} (${order.receiverPhone ?? "N/A"})',
            style: GoogleFonts.krub(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B22),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.shippingAddress ?? 'ไม่ได้ระบุที่อยู่',
            style: GoogleFonts.krub(
              fontSize: 13.5,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopAndItemsCard(BuildContext context, OrderModel order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0EAE6), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Title Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.storefront_rounded, size: 20, color: Color(0xFF2A9D8F)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.shopName ?? 'ร้านค้าชุมชน',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.krub(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D2B22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (order.shopId != null && order.shopId!.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.shopDetail, arguments: order.shopId);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF4F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ดูร้านค้า',
                            style: GoogleFonts.krub(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2A9D8F),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF2A9D8F)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEF4F1)),

          // Items List
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 58,
                          height: 58,
                          color: const Color(0xFFF4F6F5),
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
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0D2B22),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
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
                      const SizedBox(width: 8),
                      Text(
                        '฿${item.totalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.krub(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D2B22),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard(BuildContext context, OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0EAE6), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_rounded, color: Color(0xFF2A9D8F), size: 20),
              const SizedBox(width: 8),
              Text(
                'ข้อมูลการชำระเงิน',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D2B22),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFEEF4F1)),
          _buildRow('หมายเลขคำสั่งซื้อ', order.orderNumber ?? 'N/A'),
          const SizedBox(height: 8),
          _buildRow('ยอดรวมสินค้า', '฿${order.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildRow(
            'ค่าจัดส่ง (${order.shippingMethod ?? "Standard"})',
            '฿${order.shippingFee.toStringAsFixed(2)}',
          ),
          const Divider(height: 20, color: Color(0xFFEEF4F1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ยอดชำระสุทธิ',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D2B22),
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

          if (order.slipImageUrl != null && order.slipImageUrl!.isNotEmpty) ...[
            const Divider(height: 24, color: Color(0xFFEEF4F1)),
            Text(
              'หลักฐานการชำระเงิน (สลิป)',
              style: GoogleFonts.krub(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D2B22),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _showImageModal(context, order.slipImageUrl!);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  order.slipImageUrl!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 80,
                    color: const Color(0xFFF4F6F5),
                    child: const Center(
                      child: Text('ไม่สามารถโหลดรูปสลิปได้'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.krub(fontSize: 14, color: Colors.grey[700]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.krub(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B22),
            ),
          ),
        ),
      ],
    );
  }

  void _showImageModal(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
