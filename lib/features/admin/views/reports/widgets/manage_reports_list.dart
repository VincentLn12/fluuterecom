import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_reports_controller.dart';
import 'admin_report_card.dart';

class ManageReportsList extends StatelessWidget {
  const ManageReportsList({super.key, required this.controller});

  final AdminReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AdminColors.primary),
        );
      }
      if (controller.reports.isEmpty) {
        return Center(
          child: Text(
            'ไม่มีรายงานการร้องเรียน',
            style: GoogleFonts.krub(color: AdminColors.textSecondary),
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.reports.length,
        itemBuilder: (context, index) => AdminReportCard(
          report: controller.reports[index],
          controller: controller,
        ),
      );
    });
  }
}
