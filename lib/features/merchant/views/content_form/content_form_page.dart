import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'package:projecte/features/merchant/controllers/content_form_controller.dart';
import 'package:projecte/features/merchant/views/content_form/widgets/content_form_section_card.dart';
import 'package:projecte/features/merchant/views/content_form/widgets/content_form_submit_button.dart';
import 'package:projecte/features/merchant/views/content_form/widgets/content_status_selector.dart';
import 'package:projecte/features/merchant/views/content_form/widgets/shop_link_banner.dart';
import 'package:projecte/features/merchant/views/content_form/widgets/youtube_thumbnail_preview.dart';

class ContentFormPage extends GetView<ContentFormController> {
  const ContentFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditing.value
                ? 'แก้ไขเรื่องราวร้านค้า'
                : 'เขียนเรื่องราวร้านค้าใหม่',
            style: GoogleFonts.krub(fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: Obx(() {
        if (controller.isLoadingForm.value) {
          return const LoadingWidget(message: 'กำลังโหลดข้อมูลฟอร์ม...');
        }

        final shop = controller.shop.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (shop != null) ...[
                ShopLinkBanner(shopName: shop.shopName),
                const SizedBox(height: 20),
              ],

              // Section 1: Basic Info
              ContentFormSectionCard(
                title: 'ข้อมูลเรื่องราว / คอนเทนต์',
                icon: Icons.article_outlined,
                children: [
                  // Title
                  TextFormField(
                    controller: controller.titleController,
                    style: GoogleFonts.krub(),
                    decoration: _inputDecoration(
                      label: 'ชื่อเรื่องราว / หัวข้อข่าวสาร *',
                      hint:
                          'เช่น เรื่องเล่าความเป็นมาของร้าน หรือ โปรโมชั่นพิเศษ...',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Dropdown
                  Obx(() {
                    final items = controller.categories;
                    final selectedVal = controller.selectedCategoryId.value;
                    final validVal =
                        items.any(
                          (c) =>
                              (c['contentCategoryId']?.toString() ??
                                  c['id']?.toString()) ==
                              selectedVal,
                        )
                        ? selectedVal
                        : (items.isNotEmpty
                              ? (items.first['contentCategoryId']?.toString() ??
                                    items.first['id']?.toString())
                              : null);

                    return DropdownButtonFormField<String>(
                      initialValue: validVal,
                      style: GoogleFonts.krub(color: const Color(0xFF1E293B)),
                      decoration: _inputDecoration(label: 'หมวดหมู่บทความ *'),
                      items: items.map((cat) {
                        final id =
                            cat['contentCategoryId']?.toString() ??
                            cat['id']?.toString() ??
                            '';
                        final name =
                            cat['categoryName']?.toString() ??
                            cat['name']?.toString() ??
                            'หมวดหมู่';
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(name, style: GoogleFonts.krub()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.selectedCategoryId.value = val;
                      },
                    );
                  }),
                  const SizedBox(height: 16),

                  // Summary
                  TextFormField(
                    controller: controller.summaryController,
                    style: GoogleFonts.krub(),
                    maxLines: 2,
                    decoration: _inputDecoration(
                      label: 'สรุปย่อเรื่องราว (Summary)',
                      hint: 'ข้อความเกริ่นนำสั้นๆ สำหรับแสดงบนหน้าการ์ด...',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Full Body Content
                  TextFormField(
                    controller: controller.bodyController,
                    style: GoogleFonts.krub(),
                    maxLines: 6,
                    decoration: _inputDecoration(
                      label: 'เนื้อหาฉบับเต็ม *',
                      hint:
                          'กรอกเนื้อหาและรายละเอียดทั้งหมดของเรื่องราวที่นี่...',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section 2: Location & District
              ContentFormSectionCard(
                title: 'พื้นที่และตำแหน่งสถานที่',
                icon: Icons.location_on_outlined,
                children: [
                  Obx(() {
                    final dists = controller.districts;
                    final selDist = controller.selectedDistrictId.value;
                    final validDist = dists.any((d) => d.districtId == selDist)
                        ? selDist
                        : null;

                    return DropdownButtonFormField<String>(
                      initialValue: validDist,
                      style: GoogleFonts.krub(color: const Color(0xFF1E293B)),
                      decoration: _inputDecoration(label: 'อำเภอ'),
                      items: dists.map((d) {
                        return DropdownMenuItem<String>(
                          value: d.districtId,
                          child: Text(
                            d.districtName,
                            style: GoogleFonts.krub(),
                          ),
                        );
                      }).toList(),
                      onChanged: controller.onDistrictChanged,
                    );
                  }),
                  const SizedBox(height: 16),

                  Obx(() {
                    final subs = controller.subDistricts;
                    final selSub = controller.selectedSubDistrictId.value;
                    final validSub = subs.any((s) => s.subDistrictId == selSub)
                        ? selSub
                        : null;

                    return DropdownButtonFormField<String>(
                      initialValue: validSub,
                      style: GoogleFonts.krub(color: const Color(0xFF1E293B)),
                      decoration: _inputDecoration(label: 'ตำบล'),
                      items: subs.map((s) {
                        return DropdownMenuItem<String>(
                          value: s.subDistrictId,
                          child: Text(
                            s.subDistrictName,
                            style: GoogleFonts.krub(),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          controller.selectedSubDistrictId.value = val,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // Section 3: Media & Status
              ContentFormSectionCard(
                title: 'วิดีโอ YouTube และสถานะการเผยแพร่',
                icon: Icons.play_circle_outline_rounded,
                children: [
                  // YouTube URL
                  TextFormField(
                    controller: controller.youtubeUrlController,
                    style: GoogleFonts.krub(),
                    onChanged: (_) => controller.update(),
                    decoration: _inputDecoration(
                      label: 'ลิงก์วิดีโอ YouTube (ถ้ามี)',
                      hint: 'https://www.youtube.com/watch?v=...',
                    ),
                  ),
                  const SizedBox(height: 12),

                  YoutubeThumbnailPreview(controller: controller),
                  const SizedBox(height: 16),

                  const ContentStatusSelector(),
                ],
              ),
              const SizedBox(height: 30),

              const ContentFormSubmitButton(),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  InputDecoration _inputDecoration({required String label, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.krub(color: const Color(0xFF64748B)),
      hintStyle: GoogleFonts.krub(color: const Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF047857), width: 1.5),
      ),
    );
  }
}
