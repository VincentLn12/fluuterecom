import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../controllers/admin_reports_controller.dart';
import 'widgets/manage_reports_filter.dart';
import 'widgets/manage_reports_list.dart';

class ReportsPage extends GetView<AdminReportsController> {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminReportsController>()) {
      Get.put(AdminReportsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'รายงานการร้องเรียน (Reports & Violations)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.white),
            tooltip: 'ส่งออกรายงาน (Exports)',
            onPressed: () => Get.toNamed(AppRoutes.adminExports),
          ),
        ],
      ),
      body: Column(
        children: [
          ManageReportsFilter(controller: controller),
          Expanded(child: ManageReportsList(controller: controller)),
        ],
      ),
    );
  }
}
