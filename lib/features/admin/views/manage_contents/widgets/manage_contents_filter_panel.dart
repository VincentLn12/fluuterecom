import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';

class ManageContentsFilterPanel extends StatelessWidget {
  const ManageContentsFilterPanel({super.key, required this.controller});

  final AdminContentsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('', 'ทั้งหมด'),
                _filterChip('Published', 'เผยแพร่แล้ว (Published)'),
                _filterChip('Draft', 'ร่าง (Draft)'),
                _filterChip('Pending', 'รอตรวจสอบ (Pending)'),
                _filterChip('Archived', 'เก็บกรุ (Archived)'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'หน้า ${controller.currentPage.value} จาก ${controller.totalPages.value}',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    'แสดง: ',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  DropdownButton<int>(
                    value: controller.pageSize.value,
                    isDense: true,
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: AdminColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    items: const [
                      DropdownMenuItem(value: 10, child: Text('10 รายการ')),
                      DropdownMenuItem(value: 20, child: Text('20 รายการ')),
                      DropdownMenuItem(value: 50, child: Text('50 รายการ')),
                      DropdownMenuItem(value: 100, child: Text('100 รายการ')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.loadContents(page: 1, size: value);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String value, String label) {
    final selected = controller.selectedStatusFilter.value == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.krub(
            fontSize: 11,
            color: selected ? Colors.white : AdminColors.textPrimary,
          ),
        ),
        selected: selected,
        selectedColor: AdminColors.primary,
        backgroundColor: Colors.grey[200],
        onSelected: (isSelected) {
          if (isSelected) {
            controller.selectedStatusFilter.value = value;
            controller.loadContents(page: 1);
          }
        },
      ),
    );
  }
}
