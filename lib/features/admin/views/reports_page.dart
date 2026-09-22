import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_reports_controller.dart';

class ReportsPage extends GetView<AdminReportsController> {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminReportsController>()) {
      Get.put(AdminReportsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'รายงานการร้องเรียน (Reports & Violations)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.white),
            tooltip: 'ส่งออกรายงาน (Exports)',
            onPressed: () => Get.toNamed(AppRoutes.adminExports),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip('', 'ทั้งหมด'),
                    _buildChip('Pending', 'รอดำเนินการ (Pending)'),
                    _buildChip('InProgress', 'กำลังตรวจสอบ (InProgress)'),
                    _buildChip('Resolved', 'แก้ไขแล้ว (Resolved)'),
                    _buildChip('Dismissed', 'ยกเลิกคำร้อง (Dismissed)'),
                  ],
                ),
              ),
            ),
          ),

          // Reports List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final reports = controller.reports;
              if (reports.isEmpty) {
                return Center(
                  child: Text(
                    'ไม่มีรายงานการร้องเรียน',
                    style: GoogleFonts.krub(color: AppColors.textSecondary),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final rep = reports[index];
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
                                rep.targetLabel,
                                style: GoogleFonts.krub(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStatusBadge(rep.status),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'สาเหตุ: ${rep.reason}',
                          style: GoogleFonts.krub(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.error,
                          ),
                        ),
                        if (rep.description != null &&
                            rep.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            rep.description!,
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
                                'วันที่: ${rep.createdAt}',
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
                              onSelected: (status) => controller
                                  .updateReportStatus(rep.reportId, status),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'InProgress',
                                  child: Text('กำลังตรวจสอบ (InProgress)'),
                                ),
                                const PopupMenuItem(
                                  value: 'Resolved',
                                  child: Text('แก้ไขแล้ว (Resolved)'),
                                ),
                                const PopupMenuItem(
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
                                  style: GoogleFonts.krub(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String value, String label) {
    final isSelected = controller.selectedStatusFilter.value == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.krub(
            fontSize: 11,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primary,
        onSelected: (selected) {
          if (selected) {
            controller.selectedStatusFilter.value = value;
            controller.loadReports();
          }
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    switch (status.toLowerCase()) {
      case 'resolved':
        bg = AppColors.primary.withOpacity(0.12);
        text = AppColors.primary;
        break;
      case 'inprogress':
        bg = Colors.blue.withOpacity(0.12);
        text = Colors.blue;
        break;
      case 'pending':
        bg = AppColors.error.withOpacity(0.12);
        text = AppColors.error;
        break;
      default:
        bg = Colors.grey.withOpacity(0.12);
        text = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: GoogleFonts.krub(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }
}
