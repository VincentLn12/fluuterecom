import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/admin/models/admin_dashboard_model.dart';

class AdminDashboardAlertsBanner extends StatelessWidget {
  const AdminDashboardAlertsBanner({super.key, required this.alerts});

  final AdminDashboardAlerts alerts;

  @override
  Widget build(BuildContext context) {
    if (alerts.pendingSlips == 0 &&
        alerts.pendingPayoutOrders == 0 &&
        alerts.pendingShipmentOrders == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEEBA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFF856404)),
              const SizedBox(width: 8),
              Text(
                'รายการที่ต้องการการดำเนินการเร่งด่วน',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color(0xFF856404),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (alerts.pendingSlips > 0)
                ActionChip(
                  avatar: const Icon(
                    Icons.receipt_long_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text('สลิปรอยืนยัน ${alerts.pendingSlips} รายการ'),
                  backgroundColor: AppColors.accent,
                  labelStyle: GoogleFonts.krub(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.adminOrders),
                ),
              if (alerts.pendingPayoutOrders > 0)
                ActionChip(
                  avatar: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'ร้านค้ารอโอนเงิน ${alerts.pendingPayoutOrders} รายการ',
                  ),
                  backgroundColor: AppColors.primary,
                  labelStyle: GoogleFonts.krub(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.adminPayouts),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
