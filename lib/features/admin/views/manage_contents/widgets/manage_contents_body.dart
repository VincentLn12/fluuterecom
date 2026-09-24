import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_contents_controller.dart';
import '../../../models/admin_category_model.dart';
import '../../../models/admin_content_model.dart';
import 'admin_content_card.dart';
import 'admin_content_category_card.dart';
import 'manage_contents_filter_panel.dart';
import 'manage_contents_pagination.dart';

class ManageContentsBody extends StatelessWidget {
  const ManageContentsBody({
    super.key,
    required this.controller,
    required this.onEditContent,
    required this.onEditCategory,
    required this.onBindTags,
  });

  final AdminContentsController controller;
  final ValueChanged<AdminContentItem?> onEditContent;
  final ValueChanged<ContentCategoryAdmin?> onEditCategory;
  final ValueChanged<AdminContentItem> onBindTags;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.activeTab.value == 0) {
        return Column(
          children: [
            ManageContentsFilterPanel(controller: controller),
            Expanded(child: _contentList()),
            ManageContentsPagination(controller: controller),
          ],
        );
      }
      return _categoryList();
    });
  }

  Widget _contentList() {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (controller.contents.isEmpty) {
      return Center(
        child: Text('ไม่มีบทความในระบบ', style: GoogleFonts.krub()),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: controller.contents.length,
      itemBuilder: (context, index) {
        final item = controller.contents[index];
        return AdminContentCard(
          item: item,
          controller: controller,
          onEdit: () => onEditContent(item),
          onBindTags: () => onBindTags(item),
        );
      },
    );
  }

  Widget _categoryList() {
    if (controller.isCatLoading.value) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (controller.contentCategories.isEmpty) {
      return Center(
        child: Text('ไม่มีหมวดหมู่บทความ', style: GoogleFonts.krub()),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.contentCategories.length,
      itemBuilder: (context, index) {
        final category = controller.contentCategories[index];
        return AdminContentCategoryCard(
          category: category,
          controller: controller,
          onEdit: () => onEditCategory(category),
        );
      },
    );
  }
}
