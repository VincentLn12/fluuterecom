import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/admin/controllers/admin_payouts_controller.dart';

class AdminPayoutsTabBar extends StatelessWidget {
  const AdminPayoutsTabBar({super.key, required this.controller});

  final AdminPayoutsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Obx(
        () => Row(
          children: [
            _buildTab('รายการรอโอนเงิน', 0),
            _buildTab('ประวัติการโอนสำเร็จ', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = controller.activeTab.value == index;
    return Expanded(
      child: InkWell(
        onTap: () => controller.switchTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.accent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
