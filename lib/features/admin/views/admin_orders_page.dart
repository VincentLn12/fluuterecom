import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_orders_controller.dart';
import '../models/admin_order_slip_model.dart';

class AdminOrdersPage extends GetView<AdminOrdersController> {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminOrdersController>()) {
      Get.put(AdminOrdersController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'ตรวจสอบสลิปการชำระเงิน',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.loadPendingSlips(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final groups = controller.pendingSlips;

        if (groups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, size: 64, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(
                  'ไม่มีสลิปรอตรวจสอบในขณะนี้',
                  style: GoogleFonts.krub(fontSize: 16, color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return _buildSlipGroupCard(context, group);
          },
        );
      }),
    );
  }

  Widget _buildSlipGroupCard(BuildContext context, AdminPendingSlipGroup group) {
    final orderIds = group.orders.map((o) => o.id).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buyer & Amount Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.buyerName ?? 'ลูกค้า',
                        style: GoogleFonts.krub(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (group.buyerPhone != null)
                        Text(
                          'โทร: ${group.buyerPhone}',
                          style: GoogleFonts.krub(fontSize: 12, color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '฿${group.totalGroupAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Slip Thumbnail & Orders List
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Slip Image Thumbnail
                GestureDetector(
                  onTap: () => _showFullSlipModal(context, group.slipImageUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Image.network(
                          group.slipImageUrl,
                          width: 90,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 90,
                            height: 120,
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                        Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.zoom_in, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Orders in this slip group
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รายการออเดอร์ในสลิปนี้ (${group.orders.length}):',
                        style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      ...group.orders.map((o) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '• #${o.orderNumber} (฿${o.totalAmount.toStringAsFixed(2)})',
                              style: GoogleFonts.krub(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: Text('ปฏิเสธสลิป', style: GoogleFonts.krub(fontWeight: FontWeight.bold)),
                    onPressed: () => controller.verifySlip(orderIds, 'Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: Text('อนุมัติสลิป', style: GoogleFonts.krub(fontWeight: FontWeight.bold)),
                    onPressed: () => controller.verifySlip(orderIds, 'Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFullSlipModal(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
