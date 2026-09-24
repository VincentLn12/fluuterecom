import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/admin_products_controller.dart';

class ManageProductsStatusFilter extends StatelessWidget {
  const ManageProductsStatusFilter({super.key, required this.controller});

  final AdminProductsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                'กรองสถานะ: ',
                style: GoogleFonts.krub(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              _statusChip('ทั้งหมด', ''),
              const SizedBox(width: 6),
              _statusChip('วางขาย (Active)', 'Active'),
              const SizedBox(width: 6),
              _statusChip('ระงับการขาย (Inactive)', 'Inactive'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String label, String status) {
    return ChoiceChip(
      label: Text(label, style: GoogleFonts.krub(fontSize: 11)),
      selected: controller.selectedStatus.value == status,
      onSelected: (selected) {
        if (selected) {
          controller.selectedStatus.value = status;
          controller.loadProducts(page: 1);
        }
      },
    );
  }
}
