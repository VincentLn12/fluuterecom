import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_tags_controller.dart';
import '../../../models/admin_tag_model.dart';

class ManageTagFormDialog {
  static Future<void> show(
    BuildContext context, {
    required AdminTagsController controller,
    AdminTag? tag,
  }) async {
    final nameCtrl = TextEditingController(text: tag?.tagName ?? '');

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          tag == null ? 'เพิ่มแท็กใหม่' : 'แก้ไขแท็ก',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: 'ชื่อแท็ก (Tag Name)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          if (tag != null)
            TextButton(
              onPressed: () async {
                await controller.deleteTag(tag.tagId);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(
                'ลบ',
                style: GoogleFonts.krub(color: AdminColors.error),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.primary),
            onPressed: () async {
              if (tag == null) {
                await controller.createTag(nameCtrl.text.trim());
              } else {
                await controller.updateTag(
                  tag.tagId,
                  nameCtrl.text.trim(),
                  'Active',
                );
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('บันทึก', style: GoogleFonts.krub(color: Colors.white)),
          ),
        ],
      ),
    );
    nameCtrl.dispose();
  }
}
