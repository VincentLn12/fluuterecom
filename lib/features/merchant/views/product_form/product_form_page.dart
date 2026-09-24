import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_basic_fields.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_image_picker.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_description_field.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_section_card.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_status_toggle.dart';
import 'package:projecte/features/merchant/views/product_form/widgets/product_form_submit_button.dart';

class ProductFormPage extends GetView<ProductFormController> {
  const ProductFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(
          controller.editingProduct != null ? 'แก้ไขสินค้า' : 'เพิ่มสินค้าใหม่',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดหมวดหมู่สินค้า...');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductFormSectionCard(
                  title: 'ข้อมูลสินค้า',
                  icon: Icons.inventory_2_outlined,
                  child: Column(
                    children: [
                      ProductFormBasicFields(controller: controller),
                      const SizedBox(height: 14),
                      ProductFormImagePicker(controller: controller),
                      const SizedBox(height: 14),
                      ProductFormDescriptionField(controller: controller),
                      const SizedBox(height: 14),
                      ProductFormStatusToggle(controller: controller),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ProductFormSubmitButton(controller: controller),
              ],
            ),
          ),
        );
      }),
    );
  }
}
