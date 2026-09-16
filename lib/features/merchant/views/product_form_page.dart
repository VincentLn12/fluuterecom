import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/product_form_controller.dart';

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
                _buildCardContainer(
                  title: 'ข้อมูลสินค้า',
                  icon: Icons.inventory_2_outlined,
                  children: [
                    AppTextField(
                      labelText: 'ชื่อสินค้า *',
                      hintText: 'ระบุชื่อสินค้า เช่น น้ำพริกเผาแม่ทองสุข',
                      controller: controller.nameController,
                      validator: (v) => v == null || v.trim().isEmpty ? 'กรุณากรอกชื่อสินค้า' : null,
                    ),
                    const SizedBox(height: 14),
                    Obx(() {
                      final categoryEntries = controller.categories.map((c) {
                        final id = c['productCategoryId']?.toString() ?? c['id']?.toString() ?? '';
                        final name = c['categoryName']?.toString() ?? c['name']?.toString() ?? '';
                        return MapEntry(id, name);
                      }).where((entry) => entry.key.isNotEmpty).toList();

                      final uniqueMap = <String, String>{};
                      for (final item in categoryEntries) {
                        uniqueMap[item.key] = item.value;
                      }

                      final selectedVal = controller.selectedCategoryId.value;
                      final validValue = (selectedVal != null && uniqueMap.containsKey(selectedVal))
                          ? selectedVal
                          : null;

                      return DropdownButtonFormField<String>(
                        value: validValue,
                        decoration: _inputDecoration('หมวดหมู่สินค้า'),
                        items: uniqueMap.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value, style: GoogleFonts.krub()),
                          );
                        }).toList(),
                        onChanged: (val) => controller.selectedCategoryId.value = val,
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
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'กรุณากรอกราคา';
                              if (double.tryParse(v.trim()) == null) return 'ระบุตัวเลขเท่านั้น';
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
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'กรุณากรอกสต็อก';
                              if (int.tryParse(v.trim()) == null) return 'ระบุจำนวนเต็ม';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Image Upload Section
                    Obx(() {
                      final localPath = controller.selectedCoverImagePath.value;
                      final existingUrl = controller.editingProduct?.imageUrl;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'รูปปกสินค้า',
                            style: GoogleFonts.krub(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Image Preview Container
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: () {
                                      if (localPath != null && localPath.isNotEmpty) {
                                        return Image.file(
                                          File(localPath),
                                          fit: BoxFit.cover,
                                        );
                                      } else if (existingUrl != null && existingUrl.isNotEmpty) {
                                        return Image.network(
                                          existingUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'ไม่สามารถโหลดรูปภาพเดิมได้',
                                                  style: GoogleFonts.krub(color: Colors.red.shade700, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_a_photo_outlined, size: 48, color: Colors.grey.shade400),
                                              const SizedBox(height: 8),
                                              Text(
                                                'ยังไม่ได้เลือกรูปภาพสินค้า',
                                                style: GoogleFonts.krub(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }(),
                                  ),
                                ),
                                if (localPath != null && localPath.isNotEmpty)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () => controller.removeSelectedCoverImage(),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Picker Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => controller.pickCoverImage(ImageSource.gallery),
                                  icon: const Icon(Icons.photo_library, size: 18, color: Color(0xFF059669)),
                                  label: Text(
                                    'คลังภาพ',
                                    style: GoogleFonts.krub(
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF059669),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    side: const BorderSide(color: Color(0xFF059669)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => controller.pickCoverImage(ImageSource.camera),
                                  icon: const Icon(Icons.camera_alt, size: 18, color: Color(0xFF0284C7)),
                                  label: Text(
                                    'ถ่ายภาพ',
                                    style: GoogleFonts.krub(
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0284C7),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    side: const BorderSide(color: Color(0xFF0284C7)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 14),
                    AppTextField(
                      labelText: 'รายละเอียดสินค้า',
                      hintText: 'อธิบายรายละเอียดของสินค้า ขนาด หรือจุดเด่น',
                      controller: controller.descriptionController,
                    ),
                    const SizedBox(height: 14),
                    Obx(() {
                      final isActive = controller.status.value == 'Active';
                      return SwitchListTile(
                        title: Text('เปิดขายสินค้านี้', style: GoogleFonts.krub(fontWeight: FontWeight.bold)),
                        subtitle: Text(isActive ? 'สินค้ากำลังแสดงผลในร้านค้า' : 'ซ่อนสินค้านี้ชั่วคราว', style: GoogleFonts.krub(fontSize: 12)),
                        value: isActive,
                        activeThumbColor: const Color(0xFF047857),
                        onChanged: (val) => controller.status.value = val ? 'Active' : 'Inactive',
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(() {
                  return AppButton(
                    text: controller.editingProduct != null ? 'บันทึกการแก้ไข' : 'เพิ่มสินค้าเข้าสู่ร้าน',
                    isLoading: controller.isSaving.value,
                    onPressed: () => controller.submitProduct(),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCardContainer({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF059669), size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.krub(color: const Color(0xFF475569), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF059669), width: 1.8),
      ),
    );
  }
}
