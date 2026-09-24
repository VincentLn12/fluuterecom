import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/theme/app_colors.dart';

class AdminPayoutsEmptyState extends StatelessWidget {
  const AdminPayoutsEmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.krub(color: AppColors.textSecondary),
      ),
    );
  }
}
