import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    AppTextField(
                      labelText: 'URL รูปปกสินค้า *',
                      hintText: 'https://example.com/image.jpg',
                      controller: controller.imageUrlController,
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: controller.imageUrlController,
                      builder: (context, value, _) {
                        if (value.text.trim().isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          height: 180,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              value.text.trim(),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Text(
                                  'ไม่สามารถโหลดรูปภาพจาก URL นี้ได้',
                                  style: GoogleFonts.krub(color: Colors.red.shade700, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
