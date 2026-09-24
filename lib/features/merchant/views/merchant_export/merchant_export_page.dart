import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_hero_header.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_type_selector.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_date_range_selector.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_format_selector.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_order_filters.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_submit_button.dart';
import 'package:projecte/features/merchant/controllers/merchant_export_controller.dart';

class MerchantExportPage extends GetView<MerchantExportController> {
  const MerchantExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          'ส่งออกรายงานร้านค้า (Export Reports)',
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
              colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF059669)],
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
            const MerchantExportHeroHeader(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MerchantExportTypeSelector(controller: controller),

                  MerchantExportDateRangeSelector(controller: controller),

                  MerchantExportFormatSelector(controller: controller),

                  MerchantExportOrderFilters(controller: controller),

                  MerchantExportSubmitButton(controller: controller),

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
