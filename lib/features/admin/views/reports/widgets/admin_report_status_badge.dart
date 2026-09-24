import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';

class AdminReportStatusBadge extends StatelessWidget {
  const AdminReportStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status.toLowerCase()) {
      'resolved' => (
        AppColors.primary.withValues(alpha: 0.12),
        AppColors.primary,
      ),
      'inprogress' => (Colors.blue.withValues(alpha: 0.12), Colors.blue),
      'pending' => (AppColors.error.withValues(alpha: 0.12), AppColors.error),
      _ => (Colors.grey.withValues(alpha: 0.12), Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: GoogleFonts.krub(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: foreground,
        ),
      ),
    );
  }
}
