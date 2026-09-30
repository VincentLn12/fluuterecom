import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../../models/admin_tag_model.dart';

class AdminTagChip extends StatelessWidget {
  const AdminTagChip({super.key, required this.tag, required this.onEdit});

  final AdminTag tag;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(
        Icons.label_outlined,
        size: 16,
        color: AdminColors.primary,
      ),
      label: Text(
        tag.tagName,
        style: GoogleFonts.krub(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.white,
      deleteIcon: const Icon(Icons.edit_outlined, size: 16, color: Colors.blue),
      onDeleted: onEdit,
      side: const BorderSide(color: AdminColors.border),
    );
  }
}
