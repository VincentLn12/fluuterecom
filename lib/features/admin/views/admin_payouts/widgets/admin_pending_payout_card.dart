import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/admin/controllers/admin_payouts_controller.dart';
import 'package:projecte/features/admin/models/admin_merchant_payout_model.dart';
import 'package:projecte/features/admin/views/admin_payouts/widgets/admin_confirm_payout_dialog.dart';

class AdminPendingPayoutCard extends StatelessWidget {
  const AdminPendingPayoutCard({
    super.key,
    required this.controller,
    required this.payout,
  });

  final AdminPayoutsController controller;
  final AdminMerchantPayoutGroup payout;

  @override
  Widget build(BuildContext context) {
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
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
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
                onPressed: () => AdminConfirmPayoutDialog.show(
                  context: context,
                  controller: controller,
                  payout: payout,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
