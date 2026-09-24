import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/admin/controllers/admin_export_controller.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_section_card.dart';

class AdminExportDateRangeSelector extends StatelessWidget {
  const AdminExportDateRangeSelector({super.key, required this.controller});

  final AdminExportController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AdminExportSectionCard(
          stepNumber: '2',
          title: 'เลือกช่วงวันที่รายงาน',
          icon: Icons.date_range_rounded,
          children: [
            Obx(() {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.datePresets.map((preset) {
                  final val = preset['value']!;
                  final isSelected = controller.datePreset.value == val;

                  return ChoiceChip(
                    label: Text(
                      preset['label']!,
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF334155),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: const Color(0xFFF1F5F9),
                    side: BorderSide.none,
                    onSelected: (_) => controller.applyDatePreset(val),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => controller.selectDateRange(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() {
                              final from = controller.formatDateString(
                                controller.fromDate.value,
                              );
                              final to = controller.formatDateString(
                                controller.toDate.value,
                              );
                              return Text(
                                'ช่วงวันที่: $from ถึง $to',
                                style: GoogleFonts.krub(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.edit_calendar_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
