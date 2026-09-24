import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/theme/app_colors.dart';

class AdminOrdersEmptyState extends StatelessWidget {
  const AdminOrdersEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 64,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'ไม่มีสลิปรอตรวจสอบในขณะนี้',
            style: GoogleFonts.krub(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
