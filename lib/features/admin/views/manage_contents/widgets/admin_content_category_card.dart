import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../controllers/admin_contents_controller.dart';
import '../../../models/admin_category_model.dart';

class AdminContentCategoryCard extends StatelessWidget {
  const AdminContentCategoryCard({
    super.key,
    required this.category,
    required this.controller,
    required this.onEdit,
  });

  final ContentCategoryAdmin category;
  final AdminContentsController controller;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AdminColors.primary.withValues(alpha: 0.1),
            child: const Icon(Icons.article_outlined, color: AdminColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.categoryName,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (category.description != null &&
                    category.description!.isNotEmpty)
                  Text(
                    category.description!,
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AdminColors.error),
            onPressed: () =>
                controller.deleteContentCategory(category.contentCategoryId),
          ),
        ],
      ),
    );
  }
}
