import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/admin/models/admin_merchant_payout_model.dart';

class AdminPayoutHistoryCard extends StatelessWidget {
  const AdminPayoutHistoryCard({super.key, required this.record});

  final MerchantPayoutRecord record;

  @override
  Widget build(BuildContext context) {
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
}
