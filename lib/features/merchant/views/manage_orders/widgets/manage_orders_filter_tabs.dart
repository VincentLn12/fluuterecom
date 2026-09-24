import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/manage_orders_controller.dart';

class ManageOrdersFilterTabs extends StatelessWidget {
  const ManageOrdersFilterTabs({super.key, required this.controller});

  final ManageOrdersController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      height: 56,
      child: Obx(() {
        final currentStatus = controller.selectedStatus.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          itemCount: controller.statusTabs.length,
          itemBuilder: (context, index) {
            final tab = controller.statusTabs[index];
            final isSelected = currentStatus == tab['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(
                  tab['label']!,
                  style: GoogleFonts.krub(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                    fontSize: 13,
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF047857),
                backgroundColor: const Color(0xFFF1F5F9),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF047857)
                      : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (_) => controller.changeStatusTab(tab['value']!),
              ),
            );
          },
        );
      }),
    );
  }
}
