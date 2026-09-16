import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/content_form_controller.dart';

class ContentFormPage extends GetView<ContentFormController> {
  const ContentFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isEditing.value ? 'แก้ไขเรื่องราวร้านค้า' : 'เขียนเรื่องราวร้านค้าใหม่',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        )),
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
              // Shop Auto Link Banner (Matching Vue)
              if (shop != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFEDD5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.storefront_rounded, color: Color(0xFFD96C2C), size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ผูกกับร้านค้าอัตโนมัติ',
                              style: GoogleFonts.krub(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFD96C2C),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'เรื่องราวนี้จะถูกเชื่อมกับร้าน "${shop.shopName}" และแสดงผลต่อสาธารณะ',
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                color: const Color(0xFF786B62),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Section 1: Basic Info
              _buildSectionCard(
                title: 'ข้อมูลเรื่องราว / คอนเทนต์',
                icon: Icons.article_outlined,
                children: [
                  // Title
                  TextFormField(
                    controller: controller.titleController,
                    style: GoogleFonts.krub(),
                    decoration: _inputDecoration(
                      label: 'ชื่อเรื่องราว / หัวข้อข่าวสาร *',
                      hint: 'เช่น เรื่องเล่าความเป็นมาของร้าน หรือ โปรโมชั่นพิเศษ...',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Dropdown
                  Obx(() {
                    final items = controller.categories;
                    final selectedVal = controller.selectedCategoryId.value;
                    final validVal = items.any((c) =>
                            (c['contentCategoryId']?.toString() ?? c['id']?.toString()) == selectedVal)
                        ? selectedVal
                        : (items.isNotEmpty
                            ? (items.first['contentCategoryId']?.toString() ?? items.first['id']?.toString())
                            : null);

                    return DropdownButtonFormField<String>(
                      initialValue: validVal,
                      style: GoogleFonts.krub(color: const Color(0xFF1E293B)),
                      decoration: _inputDecoration(label: 'หมวดหมู่บทความ *'),
                      items: items.map((cat) {
                        final id = cat['contentCategoryId']?.toString() ?? cat['id']?.toString() ?? '';
                        final name = cat['categoryName']?.toString() ?? cat['name']?.toString() ?? 'หมวดหมู่';
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
                      hint: 'กรอกเนื้อหาและรายละเอียดทั้งหมดของเรื่องราวที่นี่...',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section 2: Location & District
              _buildSectionCard(
                title: 'พื้นที่และตำแหน่งสถานที่',
                icon: Icons.location_on_outlined,
                children: [
                  Obx(() {
                    final dists = controller.districts;
                    final selDist = controller.selectedDistrictId.value;
                    final validDist = dists.any((d) => d.districtId == selDist) ? selDist : null;

                    return DropdownButtonFormField<String>(
                      initialValue: validDist,
                      style: GoogleFonts.krub(color: const Color(0xFF1E293B)),
                      decoration: _inputDecoration(label: 'อำเภอ'),
                      items: dists.map((d) {
                        return DropdownMenuItem<String>(
                          value: d.districtId,
                          child: Text(d.districtName, style: GoogleFonts.krub()),
                        );
                      }).toList(),
                      onChanged: controller.onDistrictChanged,
                    );
                  }),
                  const SizedBox(height: 16),

                  Obx(() {
                    final subs = controller.subDistricts;
                    final selSub = controller.selectedSubDistrictId.value;
                    final validSub = subs.any((s) => s.subDistrictId == selSub) ? selSub : null;

                    return DropdownButtonFormField<String>(
                      initialValue: validSub,
                      style: GoogleFonts.krub(color: const Color(0xFF1E293B)),
                      decoration: _inputDecoration(label: 'ตำบล'),
                      items: subs.map((s) {
                        return DropdownMenuItem<String>(
                          value: s.subDistrictId,
                          child: Text(s.subDistrictName, style: GoogleFonts.krub()),
                        );
                      }).toList(),
                      onChanged: (val) => controller.selectedSubDistrictId.value = val,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // Section 3: Media & Status
              _buildSectionCard(
                title: 'รูปภาพปก วิดีโอ และสถานะการเผยแพร่',
                icon: Icons.perm_media_outlined,
                children: [
                  // Cover Image URL
                  TextFormField(
                    controller: controller.coverImageUrlController,
                    style: GoogleFonts.krub(),
                    onChanged: (_) => controller.update(),
                    decoration: _inputDecoration(
                      label: 'URL รูปภาพปก',
                      hint: 'https://example.com/cover.jpg',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Image Preview
                  ValueListenableBuilder(
                    valueListenable: controller.coverImageUrlController,
                    builder: (context, value, _) {
                      if (value.text.trim().isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        height: 160,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
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

                  // YouTube Live Thumbnail Preview (Matching CreateContentPage)
                  Obx(() {
                    final thumb = controller.youtubeThumbnailUrl;
                    if (thumb.isEmpty) return const SizedBox.shrink();

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Image.network(
                              thumb,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Color(0xFF047857),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'พบวิดีโอ YouTube พร้อมใช้ภาพวิดีโอเป็นรูปปกบทความ',
                                  style: GoogleFonts.krub(
                                    fontSize: 12,
                                    color: const Color(0xFF047857),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Status ChoiceChips
                  Text(
                    'สถานะการเผยแพร่ *',
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    return Row(
                      children: controller.statusOptions.map((opt) {
                        final val = opt['value']!;
                        final isSel = controller.selectedStatus.value == val;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ChoiceChip(
                            label: Text(
                              opt['label']!,
                              style: GoogleFonts.krub(
                                fontSize: 13,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                color: isSel ? Colors.white : const Color(0xFF475569),
                              ),
                            ),
                            selected: isSel,
                            selectedColor: val == 'Published'
                                ? const Color(0xFF047857)
                                : const Color(0xFFD97706),
                            backgroundColor: const Color(0xFFF1F5F9),
                            side: BorderSide.none,
                            onSelected: (_) => controller.selectedStatus.value = val,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
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
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline_rounded),
                  label: Text(
                    controller.isSaving.value
                        ? 'กำลังบันทึกข้อมูล...'
                        : (controller.isEditing.value ? 'บันทึกการแก้ไข' : 'บันทึกเรื่องราว'),
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF047857), size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          ...children,
        ],
      ),
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
