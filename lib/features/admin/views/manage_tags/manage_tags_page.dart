import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../controllers/admin_tags_controller.dart';
import '../../models/admin_tag_model.dart';
import 'widgets/manage_tag_form_dialog.dart';
import 'widgets/manage_tags_list.dart';

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
        onPressed: () =>
            ManageTagFormDialog.show(context, controller: controller),
        child: const Icon(Icons.add),
      ),
      body: ManageTagsList(
        controller: controller,
        onEdit: (AdminTag tag) =>
            ManageTagFormDialog.show(context, controller: controller, tag: tag),
      ),
    );
  }
}
