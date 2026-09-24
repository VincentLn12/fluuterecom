import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_reports_controller.dart';

class ManageReportsFilter extends StatelessWidget {
  const ManageReportsFilter({super.key, required this.controller});

  final AdminReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip('', 'ทั้งหมด'),
              _filterChip('Pending', 'รอดำเนินการ (Pending)'),
              _filterChip('InProgress', 'กำลังตรวจสอบ (InProgress)'),
              _filterChip('Resolved', 'แก้ไขแล้ว (Resolved)'),
              _filterChip('Dismissed', 'ยกเลิกคำร้อง (Dismissed)'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String value, String label) {
    final selected = controller.selectedStatusFilter.value == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.krub(
            fontSize: 11,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
        selected: selected,
        selectedColor: AppColors.primary,
        onSelected: (isSelected) {
          if (isSelected) {
            controller.selectedStatusFilter.value = value;
            controller.loadReports();
          }
        },
      ),
    );
  }
}
