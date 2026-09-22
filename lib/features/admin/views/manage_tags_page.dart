import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_tags_controller.dart';
import '../models/admin_tag_model.dart';

class ManageTagsPage extends GetView<AdminTagsController> {
  const ManageTagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminTagsController>()) {
      Get.put(AdminTagsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'จัดการแท็ก (Tag Management)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _showTagForm(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final tags = controller.tags;
        if (tags.isEmpty) {
          return Center(
            child: Text('ไม่มีแท็กในระบบ', style: GoogleFonts.krub(color: AppColors.textSecondary)),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tags.map((tag) => _buildTagChip(context, tag)).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildTagChip(BuildContext context, AdminTag tag) {
    return Chip(
      avatar: const Icon(Icons.label_outlined, size: 16, color: AppColors.primary),
      label: Text(tag.tagName, style: GoogleFonts.krub(fontSize: 13, fontWeight: FontWeight.w600)),
      backgroundColor: Colors.white,
      deleteIcon: const Icon(Icons.edit_outlined, size: 16, color: Colors.blue),
      onDeleted: () => _showTagForm(context, tag: tag),
      side: const BorderSide(color: AppColors.border),
    );
  }

  void _showTagForm(BuildContext context, {AdminTag? tag}) {
    final nameCtrl = TextEditingController(text: tag?.tagName ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tag == null ? 'เพิ่มแท็กใหม่' : 'แก้ไขแท็ก', style: GoogleFonts.krub(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'ชื่อแท็ก (Tag Name)', border: OutlineInputBorder()),
        ),
        actions: [
          if (tag != null)
            TextButton(
              onPressed: () async {
                await controller.deleteTag(tag.tagId);
                Navigator.pop(context);
              },
              child: Text('ลบ', style: GoogleFonts.krub(color: AppColors.error)),
            ),
          TextButton(onPressed: () => Navigator.pop(context), child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (tag == null) {
                await controller.createTag(nameCtrl.text.trim());
              } else {
                await controller.updateTag(tag.tagId, nameCtrl.text.trim(), 'Active');
              }
              Navigator.pop(context);
            },
            child: Text('บันทึก', style: GoogleFonts.krub(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
