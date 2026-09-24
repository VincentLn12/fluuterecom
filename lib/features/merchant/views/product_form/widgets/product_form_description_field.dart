import 'package:flutter/material.dart';
import 'package:projecte/shared/widgets/app_text_field.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';

class ProductFormDescriptionField extends StatelessWidget {
  const ProductFormDescriptionField({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      labelText: 'รายละเอียดสินค้า',
      hintText: 'อธิบายรายละเอียดของสินค้า ขนาด หรือจุดเด่น',
      controller: controller.descriptionController,
    );
  }
}
