import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/merchant/controllers/content_form_controller.dart';

class ContentStatusSelector extends GetView<ContentFormController> {
  const ContentStatusSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'สถานะการเผยแพร่ *',
          style: GoogleFonts.krub(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 8,
            children: controller.statusOptions.map((option) {
              final value = option['value']!;
              final isSelected = controller.selectedStatus.value == value;
              return ChoiceChip(
                label: Text(
                  option['label']!,
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
                selected: isSelected,
                selectedColor: value == 'Published'
                    ? const Color(0xFF047857)
                    : const Color(0xFFD97706),
                backgroundColor: const Color(0xFFF1F5F9),
                side: BorderSide.none,
                onSelected: (_) => controller.selectedStatus.value = value,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
