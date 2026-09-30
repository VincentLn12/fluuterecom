import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminReportStatusBadge extends StatelessWidget {
  const AdminReportStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status.toLowerCase()) {
      'resolved' => (
        AdminColors.successBg,
        AdminColors.success,
      ),
      'inprogress' => (AdminColors.infoBg, AdminColors.info),
      'pending' => (AdminColors.errorBg, AdminColors.error),
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
