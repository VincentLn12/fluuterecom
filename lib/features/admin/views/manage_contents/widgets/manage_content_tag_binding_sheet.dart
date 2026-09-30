import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';

class ManageContentTagBindingSheet {
  static Future<void> show(
    BuildContext context, {
    required AdminContentsController controller,
    required String contentId,
    required String title,
  }) async {
    controller.loadContentTags(contentId);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ผูกแท็กให้กับ: $title',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.activeTags.map((tag) {
                  final isSelected = controller.selectedContentTagIds.contains(
                    tag.tagId,
                  );
                  return FilterChip(
                    label: Text(
                      tag.tagName,
                      style: GoogleFonts.krub(fontSize: 12),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(
                      0xFF8338EC,
                    ).withValues(alpha: 0.2),
                    checkmarkColor: const Color(0xFF8338EC),
                    onSelected: (selected) {
                      if (selected) {
                        controller.selectedContentTagIds.add(tag.tagId);
                      } else {
                        controller.selectedContentTagIds.remove(tag.tagId);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.primary,
                ),
                onPressed: () async {
                  final saved = await controller.saveContentTags(contentId);
                  if (saved && context.mounted) Navigator.pop(context);
                },
                child: Text(
                  'บันทึกแท็ก',
                  style: GoogleFonts.krub(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
