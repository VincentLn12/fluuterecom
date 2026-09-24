import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/shared/widgets/app_button.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';

class ProductFormSubmitButton extends StatelessWidget {
  const ProductFormSubmitButton({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppButton(
        text: controller.editingProduct != null
            ? 'บันทึกการแก้ไข'
            : 'เพิ่มสินค้าเข้าสู่ร้าน',
        isLoading: controller.isSaving.value,
        onPressed: () => controller.submitProduct(),
      );
    });
  }
}
