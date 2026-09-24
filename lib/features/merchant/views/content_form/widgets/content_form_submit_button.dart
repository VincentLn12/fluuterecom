import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/merchant/controllers/content_form_controller.dart';

class ContentFormSubmitButton extends GetView<ContentFormController> {
  const ContentFormSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: controller.isSaving.value ? null : controller.saveContent,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF047857),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          icon: controller.isSaving.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.check_circle_outline_rounded),
          label: Text(
            controller.isSaving.value
                ? 'กำลังบันทึกข้อมูล...'
                : (controller.isEditing.value
                      ? 'บันทึกการแก้ไข'
                      : 'บันทึกเรื่องราว'),
            style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
