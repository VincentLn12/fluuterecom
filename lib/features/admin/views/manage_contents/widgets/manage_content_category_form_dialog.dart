import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_contents_controller.dart';
import '../../../models/admin_category_model.dart';

class ManageContentCategoryFormDialog {
  static Future<void> show(
    BuildContext context, {
    required AdminContentsController controller,
    ContentCategoryAdmin? category,
  }) async {
    final nameCtrl = TextEditingController(text: category?.categoryName ?? '');
    final descCtrl = TextEditingController(text: category?.description ?? '');

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          category == null ? 'สร้างหมวดหมู่บทความ' : 'แก้ไขหมวดหมู่บทความ',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'ชื่อหมวดหมู่เนื้อหา',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: 'คำอธิบาย',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (category == null) {
                await controller.createContentCategory(
                  nameCtrl.text.trim(),
                  descCtrl.text.trim(),
                );
              } else {
                await controller.updateContentCategory(
                  category.contentCategoryId,
                  nameCtrl.text.trim(),
                  descCtrl.text.trim(),
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
    descCtrl.dispose();
  }
}
