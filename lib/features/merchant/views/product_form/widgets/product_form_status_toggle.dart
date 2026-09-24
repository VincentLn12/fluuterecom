import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';

class ProductFormStatusToggle extends StatelessWidget {
  const ProductFormStatusToggle({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = controller.status.value == 'Active';
      return SwitchListTile(
        title: Text(
          'เปิดขายสินค้านี้',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          isActive ? 'สินค้ากำลังแสดงผลในร้านค้า' : 'ซ่อนสินค้านี้ชั่วคราว',
          style: GoogleFonts.krub(fontSize: 12),
        ),
        value: isActive,
        activeThumbColor: const Color(0xFF047857),
        onChanged: (value) =>
            controller.status.value = value ? 'Active' : 'Inactive',
      );
    });
  }
}
