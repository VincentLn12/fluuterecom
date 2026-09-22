import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_payouts_controller.dart';
import '../models/admin_merchant_payout_model.dart';

class AdminPayoutsPage extends GetView<AdminPayoutsController> {
  const AdminPayoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminPayoutsController>()) {
      Get.put(AdminPayoutsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'โอนเงินให้ร้านค้า (Merchant Payouts)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.primary,
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.switchTab(0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: controller.activeTab.value == 0
                                  ? AppColors.accent
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Text(
                          'รายการรอโอนเงิน',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.krub(
                            fontWeight: FontWeight.bold,
                            color: controller.activeTab.value == 0
                                ? Colors.white
                                : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.switchTab(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: controller.activeTab.value == 1
                                  ? AppColors.accent
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Text(
                          'ประวัติการโอนสำเร็จ',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.krub(
                            fontWeight: FontWeight.bold,
                            color: controller.activeTab.value == 1
                                ? Colors.white
                                : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.activeTab.value == 0) {
          final pending = controller.pendingPayouts;
          if (pending.isEmpty) {
            return Center(
              child: Text(
                'ไม่มีรายการสั่งจ่ายรอโอนในขณะนี้',
                style: GoogleFonts.krub(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pending.length,
            itemBuilder: (context, index) =>
                _buildPendingCard(context, pending[index]),
          );
        } else {
          final history = controller.payoutHistory;
          if (history.isEmpty) {
            return Center(
              child: Text(
                'ยังไม่มีประวัติการโอนเงิน',
                style: GoogleFonts.krub(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) =>
                _buildHistoryCard(context, history[index]),
          );
        }
      }),
    );
  }

  Widget _buildPendingCard(
    BuildContext context,
    AdminMerchantPayoutGroup payout,
  ) {
    final orderIds = payout.orders.map((o) => o.id).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.storefront, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payout.shopName,
                        style: GoogleFonts.krub(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'ชำระแล้ว ${payout.paidOrdersCount} ออเดอร์',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '฿${payout.totalSalesAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ข้อมูลบัญชีธนาคารรับเงิน:',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  if (payout.bankName != null)
                    Text(
                      '• ธนาคาร: ${payout.bankName}',
                      style: GoogleFonts.krub(fontSize: 12),
                    ),
                  if (payout.bankAccountName != null)
                    Text(
                      '• ชื่อบัญชี: ${payout.bankAccountName}',
                      style: GoogleFonts.krub(fontSize: 12),
                    ),
                  if (payout.bankAccountNumber != null)
                    Text(
                      '• เลขบัญชี: ${payout.bankAccountNumber}',
                      style: GoogleFonts.krub(fontSize: 12),
                    ),
                  if (payout.promptPay != null)
                    Text(
                      '• PromptPay: ${payout.promptPay}',
                      style: GoogleFonts.krub(fontSize: 12),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  'ยืนยันโอนเงิน & อัปโหลดสลิป',
                  style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                ),
                onPressed: () => _showConfirmPayoutDialog(
                  context,
                  payout.shopId,
                  payout.shopName,
                  orderIds,
                  payout.totalSalesAmount,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, MerchantPayoutRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.shopName ?? 'ร้านค้า',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                '฿${record.totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'รหัสอ้างอิง: ${record.transactionRef ?? '-'} | วันที่: ${record.createdAt}',
            style: GoogleFonts.krub(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmPayoutDialog(
    BuildContext context,
    String shopId,
    String shopName,
    List<String> orderIds,
    double amount,
  ) {
    final refController = TextEditingController();
    final noteController = TextEditingController();
    final selectedFile = Rxn<File>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'ยืนยันโอนเงินให้ $shopName',
            style: GoogleFonts.krub(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ยอดเงินโอน: ฿${amount.toStringAsFixed(2)}',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: refController,
                  decoration: const InputDecoration(
                    labelText: 'หมายเลขอ้างอิงธุรกรรม (Transaction Ref)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'บันทึกช่วยจำ (Note)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        selectedFile.value = File(picked.path);
                      }
                    },
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: selectedFile.value != null
                          ? Image.file(selectedFile.value!, fit: BoxFit.cover)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'แนบหลักฐานสลิปการโอน',
                                  style: GoogleFonts.krub(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ยกเลิก',
                style: GoogleFonts.krub(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () async {
                final ok = await controller.confirmPayout(
                  shopId: shopId,
                  orderIds: orderIds,
                  transactionRef: refController.text.trim(),
                  note: noteController.text.trim(),
                  slipFile: selectedFile.value,
                );
                if (ok) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                'บันทึกการโอน',
                style: GoogleFonts.krub(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
