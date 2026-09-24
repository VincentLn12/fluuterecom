import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_contents_controller.dart';
import '../../../models/admin_content_model.dart';

class ManageContentFormDialog {
  static Future<void> show(
    BuildContext context, {
    required AdminContentsController controller,
    AdminContentItem? item,
  }) async {
    final titleCtrl = TextEditingController(text: item?.title ?? '');
    final summaryCtrl = TextEditingController(text: item?.summary ?? '');
    final ytCtrl = TextEditingController(text: item?.youtubeUrl ?? '');
    final status = item?.status ?? 'Published';

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          item == null ? 'เพิ่มบทความใหม่' : 'แก้ไขบทความ',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'หัวข้อบทความ (Title)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: summaryCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'เรื่องย่อ / เนื้อหา (Summary)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ytCtrl,
                decoration: const InputDecoration(
                  labelText: 'ลิงก์ YouTube (ถ้ามี)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              await controller.saveContent(
                id: item?.contentId,
                data: ContentFormData(
                  title: titleCtrl.text.trim(),
                  summary: summaryCtrl.text.trim(),
                  youtubeUrl: ytCtrl.text.trim(),
                  status: status,
                ),
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('บันทึก', style: GoogleFonts.krub(color: Colors.white)),
          ),
        ],
      ),
    );
    titleCtrl.dispose();
    summaryCtrl.dispose();
    ytCtrl.dispose();
  }
}
