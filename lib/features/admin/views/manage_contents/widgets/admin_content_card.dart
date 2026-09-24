import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_contents_controller.dart';
import '../../../models/admin_content_model.dart';

class AdminContentCard extends StatelessWidget {
  const AdminContentCard({
    super.key,
    required this.item,
    required this.controller,
    required this.onEdit,
    required this.onBindTags,
  });

  final AdminContentItem item;
  final AdminContentsController controller;
  final VoidCallback onEdit;
  final VoidCallback onBindTags;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.status,
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (item.summary != null && item.summary!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.summary!,
              style: GoogleFonts.krub(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF8338EC),
                  side: const BorderSide(color: Color(0xFF8338EC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.label_outlined, size: 16),
                label: Text(
                  'ผูกแท็ก (Tag Binding)',
                  style: GoogleFonts.krub(fontSize: 11),
                ),
                onPressed: onBindTags,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.archive_outlined,
                      color: AppColors.error,
                    ),
                    onPressed: () => controller.archiveContent(item.contentId),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
