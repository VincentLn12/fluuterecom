import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_tags_controller.dart';
import '../../../models/admin_tag_model.dart';
import 'admin_tag_chip.dart';

class ManageTagsList extends StatelessWidget {
  const ManageTagsList({
    super.key,
    required this.controller,
    required this.onEdit,
  });

  final AdminTagsController controller;
  final ValueChanged<AdminTag> onEdit;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AdminColors.primary),
        );
      }
      if (controller.tags.isEmpty) {
        return Center(
          child: Text(
            'ไม่มีแท็กในระบบ',
            style: GoogleFonts.krub(color: AdminColors.textSecondary),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: controller.tags
              .map((tag) => AdminTagChip(tag: tag, onEdit: () => onEdit(tag)))
              .toList(),
        ),
      );
    });
  }
}
