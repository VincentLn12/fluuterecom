import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/admin/models/admin_dashboard_model.dart';

class AdminDashboardOrderStatusBreakdown extends StatelessWidget {
  const AdminDashboardOrderStatusBreakdown({super.key, required this.counts});

  final AdminOrderStatusCounts counts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusColumn('รอชำระ', counts.pendingPayment, Colors.orange),
          _buildStatusColumn(
            'รอยืนยัน',
            counts.pendingVerification,
            AppColors.accent,
          ),
          _buildStatusColumn('กำลังส่ง', counts.shipped, Colors.blue),
          _buildStatusColumn('สำเร็จ', counts.completed, AppColors.primary),
          _buildStatusColumn('ยกเลิก', counts.cancelled, Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatusColumn(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.krub(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
