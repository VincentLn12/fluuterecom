import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/admin_export_controller.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_hero_header.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_type_selector.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_date_range_selector.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_format_selector.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_filters.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_submit_button.dart';

class AdminExportPage extends GetView<AdminExportController> {
  const AdminExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminExportController>()) {
      Get.put(AdminExportController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          'รายงานและดาวน์โหลด (Admin Exports)',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2D25), Color(0xFF1B4D3E), Color(0xFF2A9D8F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Hero Banner
            const AdminExportHeroHeader(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminExportTypeSelector(controller: controller),

                  AdminExportDateRangeSelector(controller: controller),

                  AdminExportFormatSelector(controller: controller),

                  AdminExportFilters(controller: controller),

                  AdminExportSubmitButton(controller: controller),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
