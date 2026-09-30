import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../controllers/admin_contents_controller.dart';
import '../../models/admin_content_model.dart';
import 'widgets/manage_content_category_form_dialog.dart';
import 'widgets/manage_content_form_dialog.dart';
import 'widgets/manage_content_tag_binding_sheet.dart';
import 'widgets/manage_contents_body.dart';
import 'widgets/manage_contents_tabs.dart';

class ManageAdminContentsPage extends GetView<AdminContentsController> {
  const ManageAdminContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminContentsController>()) {
      Get.put(AdminContentsController());
    }

    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: AppBar(
        backgroundColor: AdminColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'จัดการบทความ & ท่องเที่ยว (Contents)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: ManageContentsTabs(controller: controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AdminColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          if (controller.activeTab.value == 0) {
            ManageContentFormDialog.show(context, controller: controller);
          } else {
            ManageContentCategoryFormDialog.show(
              context,
              controller: controller,
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ManageContentsBody(
        controller: controller,
        onEditContent: (item) => ManageContentFormDialog.show(
          context,
          controller: controller,
          item: item,
        ),
        onEditCategory: (category) => ManageContentCategoryFormDialog.show(
          context,
          controller: controller,
          category: category,
        ),
        onBindTags: (AdminContentItem item) =>
            ManageContentTagBindingSheet.show(
              context,
              controller: controller,
              contentId: item.contentId,
              title: item.title,
            ),
      ),
    );
  }
}
