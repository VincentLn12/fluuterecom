import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_contents_controller.dart';
import '../models/admin_content_model.dart';

class ManageAdminContentsPage extends GetView<AdminContentsController> {
  const ManageAdminContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminContentsController>()) {
      Get.put(AdminContentsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'จัดการบทความ & ท่องเที่ยว (Contents)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.primary,
            child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.switchTab(0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: controller.activeTab.value == 0 ? AppColors.accent : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Text(
                            'บทความทั้งหมด',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.krub(
                              fontWeight: FontWeight.bold,
                              color: controller.activeTab.value == 0 ? Colors.white : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.switchTab(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: controller.activeTab.value == 1 ? AppColors.accent : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Text(
                            'หมวดหมู่บทความ',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.krub(
                              fontWeight: FontWeight.bold,
                              color: controller.activeTab.value == 1 ? Colors.white : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          if (controller.activeTab.value == 0) {
            _showContentForm(context);
          } else {
            _showContentCategoryForm(context);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.activeTab.value == 0) {
          final items = controller.contents;
          return Column(
            children: [
              // Filter & Page Size Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('', 'ทั้งหมด'),
                          _buildFilterChip('Published', 'เผยแพร่แล้ว (Published)'),
                          _buildFilterChip('Draft', 'ร่าง (Draft)'),
                          _buildFilterChip('Pending', 'รอตรวจสอบ (Pending)'),
                          _buildFilterChip('Archived', 'เก็บกรุ (Archived)'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'หน้า ${controller.currentPage.value} จาก ${controller.totalPages.value}',
                          style: GoogleFonts.krub(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                        Row(
                          children: [
                            Text('แสดง: ', style: GoogleFonts.krub(fontSize: 12, color: AppColors.textSecondary)),
                            const SizedBox(width: 4),
                            DropdownButton<int>(
                              value: controller.pageSize.value,
                              isDense: true,
                              style: GoogleFonts.krub(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                              items: const [
                                DropdownMenuItem(value: 10, child: Text('10 รายการ')),
                                DropdownMenuItem(value: 20, child: Text('20 รายการ')),
                                DropdownMenuItem(value: 50, child: Text('50 รายการ')),
                                DropdownMenuItem(value: 100, child: Text('100 รายการ')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  controller.loadContents(page: 1, size: val);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content Items List
              Expanded(
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : items.isEmpty
                        ? Center(child: Text('ไม่มีบทความในระบบ', style: GoogleFonts.krub()))
                        : ListView.builder(
                            padding: const EdgeInsets.all(14),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            item.status,
                                            style: GoogleFonts.krub(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (item.summary != null && item.summary!.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        item.summary!,
                                        style: GoogleFonts.krub(fontSize: 12, color: AppColors.textSecondary),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: const Color(0xFF8338EC),
                                            side: const BorderSide(color: Color(0xFF8338EC)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          icon: const Icon(Icons.label_outlined, size: 16),
                                          label: Text('ผูกแท็ก (Tag Binding)', style: GoogleFonts.krub(fontSize: 11)),
                                          onPressed: () => _showTagBindingModal(context, item.contentId, item.title),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                              onPressed: () => _showContentForm(context, item: item),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.archive_outlined, color: AppColors.error),
                                              onPressed: () => controller.archiveContent(item.contentId),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),

              // Pagination Navigation Footer
              _buildPaginationFooter(),
            ],
          );
        } else {
          if (controller.isCatLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final cats = controller.contentCategories;
          if (cats.isEmpty) {
            return Center(child: Text('ไม่มีหมวดหมู่บทความ', style: GoogleFonts.krub()));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cats.length,
            itemBuilder: (context, index) {
              final cat = cats[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.article_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.categoryName, style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 15)),
                          if (cat.description != null && cat.description!.isNotEmpty)
                            Text(cat.description!, style: GoogleFonts.krub(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: () => _showContentCategoryForm(context, category: cat),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () => controller.deleteContentCategory(cat.contentCategoryId),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }

  void _showContentForm(BuildContext context, {AdminContentItem? item}) {
    final titleCtrl = TextEditingController(text: item?.title ?? '');
    final summaryCtrl = TextEditingController(text: item?.summary ?? '');
    final ytCtrl = TextEditingController(text: item?.youtubeUrl ?? '');
    String status = item?.status ?? 'Published';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'เพิ่มบทความใหม่' : 'แก้ไขบทความ', style: GoogleFonts.krub(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'หัวข้อบทความ (Title)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: summaryCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'เรื่องย่อ / เนื้อหา (Summary)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ytCtrl,
                decoration: const InputDecoration(labelText: 'ลิงก์ YouTube (ถ้ามี)', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              final data = ContentFormData(
                title: titleCtrl.text.trim(),
                summary: summaryCtrl.text.trim(),
                youtubeUrl: ytCtrl.text.trim(),
                status: status,
              );
              await controller.saveContent(id: item?.contentId, data: data);
              Navigator.pop(context);
            },
            child: Text('บันทึก', style: GoogleFonts.krub(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showContentCategoryForm(BuildContext context, {dynamic category}) {
    final nameCtrl = TextEditingController(text: category?.categoryName ?? '');
    final descCtrl = TextEditingController(text: category?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'สร้างหมวดหมู่บทความ' : 'แก้ไขหมวดหมู่บทความ', style: GoogleFonts.krub(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'ชื่อหมวดหมู่เนื้อหา', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'คำอธิบาย', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (category == null) {
                await controller.createContentCategory(nameCtrl.text.trim(), descCtrl.text.trim());
              } else {
                await controller.updateContentCategory(category.contentCategoryId, nameCtrl.text.trim(), descCtrl.text.trim(), 'Active');
              }
              Navigator.pop(context);
            },
            child: Text('บันทึก', style: GoogleFonts.krub(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTagBindingModal(BuildContext context, String contentId, String title) {
    controller.loadContentTags(contentId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ผูกแท็กให้กับ: $title',
                style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 14),
              Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.activeTags.map((tag) {
                      final isSelected = controller.selectedContentTagIds.contains(tag.tagId);
                      return FilterChip(
                        label: Text(tag.tagName, style: GoogleFonts.krub(fontSize: 12)),
                        selected: isSelected,
                        selectedColor: const Color(0xFF8338EC).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF8338EC),
                        onSelected: (selected) {
                          if (selected) {
                            controller.selectedContentTagIds.add(tag.tagId);
                          } else {
                            controller.selectedContentTagIds.remove(tag.tagId);
                          }
                        },
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () async {
                    final ok = await controller.saveContentTags(contentId);
                    if (ok) Navigator.pop(context);
                  },
                  child: Text('บันทึกแท็ก', style: GoogleFonts.krub(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = controller.selectedStatusFilter.value == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label, style: GoogleFonts.krub(fontSize: 11, color: isSelected ? Colors.white : AppColors.textPrimary)),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: Colors.grey[200],
        onSelected: (selected) {
          if (selected) {
            controller.selectedStatusFilter.value = value;
            controller.loadContents(page: 1);
          }
        },
      ),
    );
  }

  Widget _buildPaginationFooter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.arrow_back_ios, size: 14),
            label: Text('หน้าก่อนหน้า', style: GoogleFonts.krub(fontSize: 12)),
            onPressed: controller.currentPage.value > 1
                ? () => controller.previousPage()
                : null,
          ),
          Text(
            '${controller.currentPage.value} / ${controller.totalPages.value}',
            style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.arrow_forward_ios, size: 14),
            label: Text('หน้าถัดไป', style: GoogleFonts.krub(fontSize: 12)),
            onPressed: controller.currentPage.value < controller.totalPages.value
                ? () => controller.nextPage()
                : null,
          ),
        ],
      ),
    );
  }
}
