import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/admin/controllers/admin_payouts_controller.dart';
import 'package:projecte/features/admin/models/admin_merchant_payout_model.dart';

class AdminConfirmPayoutDialog {
  const AdminConfirmPayoutDialog._();

  static void show({
    required BuildContext context,
    required AdminPayoutsController controller,
    required AdminMerchantPayoutGroup payout,
  }) {
    final shopId = payout.shopId;
    final shopName = payout.shopName;
    final orderIds = payout.orders.map((order) => order.id).toList();
    final amount = payout.totalSalesAmount;
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
