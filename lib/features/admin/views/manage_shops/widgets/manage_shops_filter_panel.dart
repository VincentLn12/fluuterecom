import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_shops_controller.dart';

class ManageShopsFilterPanel extends StatelessWidget {
  const ManageShopsFilterPanel({super.key, required this.controller});

  final AdminShopsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              controller.searchQuery.value = value;
              controller.loadShops(page: 1);
            },
            decoration: InputDecoration(
              hintText: 'ค้นหาชื่อร้านค้า...',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip('', 'ทั้งหมด'),
                  _filterChip('Pending', 'รออนุมัติ (Pending)'),
                  _filterChip('Active', 'เปิดใช้งาน (Active)'),
                  _filterChip('Suspended', 'ถูกระงับ (Suspended)'),
                  _filterChip('Closed', 'ปิดบริการ (Closed)'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String value, String label) {
    final selected = controller.selectedStatus.value == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.krub(
            fontSize: 11,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
        selected: selected,
        selectedColor: AppColors.primary,
        backgroundColor: Colors.grey[200],
        onSelected: (isSelected) {
          if (isSelected) {
            controller.selectedStatus.value = value;
            controller.loadShops(page: 1);
          }
        },
      ),
    );
  }
}
