import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/merchant_export_controller.dart';

class MerchantExportSubmitButton extends StatelessWidget {
  const MerchantExportSubmitButton({super.key, required this.controller});

  final MerchantExportController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExporting = controller.isExporting.value;

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isExporting ? null : controller.exportReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF047857),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 4,
          ),
          icon: isExporting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Icon(Icons.file_download_rounded, size: 24),
          label: Text(
            isExporting
                ? 'กำลังเตรียมและออกรายงาน...'
                : 'ดาวน์โหลดรายงานการส่งออก',
            style: GoogleFonts.krub(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    });
  }
}
