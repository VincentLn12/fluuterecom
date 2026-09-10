import 'dart:convert';
import 'dart:io';
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
          'รายละเอียดคำสั่งซื้อ',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            tooltip: 'กลับสู่หน้าหลัก',
            onPressed: () => Get.offAllNamed(AppRoutes.initial),
          ),
        ],
      ),
      body: order == null
          ? Center(
              child: Text(
                'ไม่พบข้อมูลคำสั่งซื้อ',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  color: const Color(0xFF332820),
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Status Banner Header
                  _buildStatusBanner(order),

                  const SizedBox(height: 16),

                  // 2. Shipping Address Card
                  _buildShippingAddressCard(order),

                  const SizedBox(height: 16),

                  // 3. Shop & Ordered Items Card
                  _buildShopAndItemsCard(order),

                  const SizedBox(height: 16),

                  // 4. Payment & Price Summary Card
                  _buildPaymentSummaryCard(context, order),

                  const SizedBox(height: 24),

                  // 5. Payment Button if Pending
                  if (order.orderStatus.toLowerCase() == 'pending')
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(AppRoutes.payment, arguments: order);
                        },
                        icon: const Icon(Icons.payment_rounded, size: 20),
                        label: Text(
                          'ดำเนินการชำระเงิน',
                          style: GoogleFonts.krub(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD96C2C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusBanner(OrderModel order) {
    Color bannerBg;
    IconData bannerIcon;
    String statusDesc;

    switch (order.orderStatus.toLowerCase()) {
      case 'pending':
        bannerBg = const Color(0xFFE76F51);
        bannerIcon = Icons.hourglass_empty_rounded;
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
        bannerBg = const Color(0xFF059669);
        bannerIcon = Icons.check_circle_rounded;
        statusDesc =
            'คำสั่งซื้อสำเร็จ ขอบคุณที่ร่วมอุดหนุนสินค้าโอทอปกาญจนบุรี';
        break;
      case 'cancelled':
        bannerBg = const Color(0xFF786B62);
        bannerIcon = Icons.cancel_rounded;
        statusDesc = 'คำสั่งซื้อนี้ถูกยกเลิกเรียบร้อยแล้ว';
        break;
      default:
        bannerBg = const Color(0xFFD96C2C);
        bannerIcon = Icons.info_rounded;
        statusDesc = 'สถานะคำสั่งซื้อปัจจุบันของคุณ';
    }

    final dateStr = order.createdAt != null
        ? _formatDate(order.createdAt!)
        : '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(20),
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
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'สั่งซื้อเมื่อ: $dateStr',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            bannerIcon,
            size: 44,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddressCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFFD96C2C),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'ที่อยู่สำหรับจัดส่งสินค้า',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          const SizedBox(height: 12),
          Text(
            '${order.receiverName ?? "ผู้รับสินค้า"} (${order.receiverPhone ?? "N/A"})',
            style: GoogleFonts.krub(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF332820),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.shippingAddress ?? 'ไม่ได้ระบุที่อยู่',
            style: GoogleFonts.krub(
              fontSize: 13.5,
              color: const Color(0xFF786B62),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopAndItemsCard(OrderModel order) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Title Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFD96C2C,
                          ).withValues(alpha: 0.12),
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
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF332820),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (order.shopId != null && order.shopId!.isNotEmpty)
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.shopDetail,
                        arguments: order.shopId,
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE8D9C9)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ดูร้านค้า',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD96C2C),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: Color(0xFFD96C2C),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE8D9C9)),

          // Items List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 58,
                          height: 58,
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
                                        size: 26,
                                      ),
                                )
                              : const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Color(0xFF786B62),
                                  size: 26,
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF332820),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '฿${item.unitPrice.toStringAsFixed(2)} x ${item.quantity}',
                              style: GoogleFonts.krub(
                                fontSize: 13,
                                color: const Color(0xFF786B62),
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
                          color: const Color(0xFF332820),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_rounded,
                  color: Color(0xFFD96C2C),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'สรุปยอดการชำระเงิน',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          const SizedBox(height: 14),
          _buildRow('หมายเลขคำสั่งซื้อ', '#${order.orderNumber ?? order.id}'),
          const SizedBox(height: 8),
          _buildRow('ยอดรวมสินค้า', '฿${order.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildRow(
            'ค่าจัดส่ง (${order.shippingMethod ?? "Standard"})',
            '฿${order.shippingFee.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ยอดชำระสุทธิ',
                style: GoogleFonts.krub(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
              Text(
                '฿${order.totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.krub(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFD96C2C),
                ),
              ),
            ],
          ),

          if (order.slipImageUrl != null && order.slipImageUrl!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE8D9C9)),
            const SizedBox(height: 14),
            Text(
              'หลักฐานการชำระเงิน (สลิป)',
              style: GoogleFonts.krub(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF332820),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _showImageModal(context, order.slipImageUrl!);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _buildSlipImageWidget(
                  order.slipImageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 13.5,
              color: const Color(0xFF786B62),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          textAlign: TextAlign.end,
          style: GoogleFonts.krub(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF332820),
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
                child: _buildSlipImageWidget(imageUrl, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildSlipImageWidget(
    String slip, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (slip.startsWith('data:image')) {
      try {
        final base64Data = slip.split(',').last;
        final bytes = base64Decode(base64Data);
        return Image.memory(bytes, width: width, height: height, fit: fit);
      } catch (_) {}
    }
    if (slip.startsWith('http://') || slip.startsWith('https://')) {
      return Image.network(
        slip,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height ?? 80,
          color: const Color(0xFFE8D9C9).withValues(alpha: 0.3),
          child: Center(
            child: Text(
              'ไม่สามารถโหลดรูปสลิปได้',
              style: GoogleFonts.krub(
                fontSize: 13,
                color: const Color(0xFF786B62),
              ),
            ),
          ),
        ),
      );
    }
    final file = File(slip);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height ?? 80,
          color: const Color(0xFFE8D9C9).withValues(alpha: 0.3),
          child: Center(
            child: Text(
              'ไม่สามารถโหลดรูปสลิปได้',
              style: GoogleFonts.krub(
                fontSize: 13,
                color: const Color(0xFF786B62),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      height: height ?? 80,
      color: const Color(0xFFE8D9C9).withValues(alpha: 0.3),
      child: Center(
        child: Text(
          'ไม่สามารถโหลดรูปสลิปได้',
          style: GoogleFonts.krub(fontSize: 13, color: const Color(0xFF786B62)),
        ),
      ),
    );
  }
}
