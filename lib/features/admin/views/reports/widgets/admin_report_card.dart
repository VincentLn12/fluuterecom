import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_reports_controller.dart';
import '../../../models/admin_report_model.dart';
import 'admin_report_status_badge.dart';

class AdminReportCard extends StatelessWidget {
  const AdminReportCard({
    super.key,
    required this.report,
    required this.controller,
  });

  final AdminReport report;
  final AdminReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  report.targetLabel,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              AdminReportStatusBadge(status: report.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'สาเหตุ: ${report.reason}',
            style: GoogleFonts.krub(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.error,
            ),
          ),
          if (report.description != null && report.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              report.description!,
              style: GoogleFonts.krub(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'วันที่: ${report.createdAt}',
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (status) =>
                    controller.updateReportStatus(report.reportId, status),
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'InProgress',
                    child: Text('กำลังตรวจสอบ (InProgress)'),
                  ),
                  PopupMenuItem(
                    value: 'Resolved',
                    child: Text('แก้ไขแล้ว (Resolved)'),
                  ),
                  PopupMenuItem(
                    value: 'Dismissed',
                    child: Text('ยกเลิกคำร้อง (Dismissed)'),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'เปลี่ยนสถานะ',
                    style: GoogleFonts.krub(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
