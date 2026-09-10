import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../orders/models/order_model.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final OrderModel? order = args is OrderModel ? args : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon Badge
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'ทำรายการสั่งซื้อสำเร็จ!',
                style: GoogleFonts.krub(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B1F17),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'ขอบคุณที่ร่วมอุดหนุนสินค้าโอทอปและของฝากชุมชนจังหวัดกาญจนบุรี',
                textAlign: TextAlign.center,
                style: GoogleFonts.krub(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Order Summary Info Box
              if (order != null) ...[
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
                    children: [
                      _buildInfoRow('หมายเลขคำสั่งซื้อ', order.orderNumber ?? 'N/A'),
                      const SizedBox(height: 8),
                      _buildInfoRow('ร้านค้า', order.shopName ?? 'ร้านค้าชุมชน'),
                      const SizedBox(height: 8),
                      _buildInfoRow('ราคารวมทั้งสิ้น', '฿${order.totalAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'สถานะการชำระเงิน',
                        order.paymentStatus == 'PendingVerify'
                            ? 'แนบสลิปแล้ว (รอตรวจสอบ)'
                            : order.statusLabel,
                      ),
                      if (order.slipImageUrl != null && order.slipImageUrl!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0xFFEADCCF)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: _buildSlipImageWidget(order.slipImageUrl!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'แนบหลักฐานการชำระเงินเรียบร้อย',
                                    style: GoogleFonts.krub(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF2E7D32),
                                    ),
                                  ),
                                  Text(
                                    'เจ้าหน้าที่จะทำการตรวจสอบยอดชำระโดยเร็วที่สุด',
                                    style: GoogleFonts.krub(
                                      fontSize: 11.5,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 36),
              ],

              // CTA Action Buttons
              ElevatedButton.icon(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.initial);
                  Get.toNamed(AppRoutes.orders);
                },
                icon: const Icon(Icons.receipt_long_rounded, size: 20),
                label: Text(
                  'ดูประวัติการสั่งซื้อของฉัน',
                  style: GoogleFonts.krub(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD96C2C),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.initial);
                },
                icon: const Icon(Icons.home_rounded, size: 20),
                label: Text(
                  'กลับสู่หน้าหลัก',
                  style: GoogleFonts.krub(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2B1F17),
                  side: const BorderSide(color: Color(0xFF2B1F17), width: 1.5),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.krub(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.krub(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2B1F17),
            ),
          ),
        ),
      ],
    );
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
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: const Color(0xFF2E7D32),
              child: const Icon(
                Icons.image_rounded,
                color: Colors.white,
                size: 24,
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
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: const Color(0xFF2E7D32),
              child: const Icon(
                Icons.image_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
      );
    }
    return Container(
      color: const Color(0xFF2E7D32),
      child: const Icon(Icons.image_rounded, color: Colors.white, size: 24),
    );
  }
}
