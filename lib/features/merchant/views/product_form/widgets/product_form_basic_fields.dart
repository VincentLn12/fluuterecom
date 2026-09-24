import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/shared/widgets/app_text_field.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_input_decoration.dart';

class ProductFormBasicFields extends StatelessWidget {
  const ProductFormBasicFields({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          labelText: 'ชื่อสินค้า *',
          hintText: 'ระบุชื่อสินค้า เช่น น้ำพริกเผาแม่ทองสุข',
          controller: controller.nameController,
          validator: (value) => value == null || value.trim().isEmpty
              ? 'กรุณากรอกชื่อสินค้า'
              : null,
        ),
        const SizedBox(height: 14),
        Obx(() {
          final categoryEntries = controller.categories
              .map((category) {
                final id =
                    category['productCategoryId']?.toString() ??
                    category['id']?.toString() ??
                    '';
                final name =
                    category['categoryName']?.toString() ??
                    category['name']?.toString() ??
                    '';
                return MapEntry(id, name);
              })
              .where((entry) => entry.key.isNotEmpty)
              .toList();

          final uniqueCategories = <String, String>{};
          for (final entry in categoryEntries) {
            uniqueCategories[entry.key] = entry.value;
          }

          final selectedCategoryId = controller.selectedCategoryId.value;
          final validValue =
              selectedCategoryId != null &&
                  uniqueCategories.containsKey(selectedCategoryId)
              ? selectedCategoryId
              : null;

          return DropdownButtonFormField<String>(
            initialValue: validValue,
            decoration: ProductFormInputDecoration.build('หมวดหมู่สินค้า'),
            items: uniqueCategories.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value, style: GoogleFonts.krub()),
              );
            }).toList(),
            onChanged: (value) => controller.selectedCategoryId.value = value,
          );
        }),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'ราคา (บาท) *',
                hintText: '0.00',
                controller: controller.priceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกราคา';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'ระบุตัวเลขเท่านั้น';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'จำนวนในสต็อก *',
                hintText: '0',
                controller: controller.quantityController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกสต็อก';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'ระบุจำนวนเต็ม';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
