import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_contents_controller.dart';

class ManageContentsPagination extends StatelessWidget {
  const ManageContentsPagination({super.key, required this.controller});

  final AdminContentsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.arrow_back_ios, size: 14),
            label: Text('หน้าก่อนหน้า', style: GoogleFonts.krub(fontSize: 12)),
            onPressed: controller.currentPage.value > 1
                ? controller.previousPage
                : null,
          ),
          Text(
            '${controller.currentPage.value} / ${controller.totalPages.value}',
            style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.arrow_forward_ios, size: 14),
            label: Text('หน้าถัดไป', style: GoogleFonts.krub(fontSize: 12)),
            onPressed:
                controller.currentPage.value < controller.totalPages.value
                ? controller.nextPage
                : null,
          ),
        ],
      ),
    );
  }
}
