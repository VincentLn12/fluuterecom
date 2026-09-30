import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';

class ManageContentsTabs extends StatelessWidget {
  const ManageContentsTabs({super.key, required this.controller});

  final AdminContentsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AdminColors.primary,
      child: Obx(
        () => Row(
          children: [
            _Tab(
              label: 'บทความทั้งหมด',
              selected: controller.activeTab.value == 0,
              onTap: () => controller.switchTab(0),
            ),
            _Tab(
              label: 'หมวดหมู่บทความ',
              selected: controller.activeTab.value == 1,
              onTap: () => controller.switchTab(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? AdminColors.accent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
