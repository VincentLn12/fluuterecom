import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../contents/models/content_model.dart';
import '../controllers/manage_contents_controller.dart';

class ManageContentsPage extends GetView<ManageContentsController> {
  const ManageContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(
          'จัดการบทความ & ประชาสัมพันธ์',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF047857), size: 26),
            onPressed: () async {
              final res = await Get.toNamed(AppRoutes.myShopContentForm);
              if (res == true) {
                controller.loadContents();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Action Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => controller.searchQuery.value = val,
                    style: GoogleFonts.krub(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'ค้นหาหัวข้อบทความ / ข่าวสาร...',
                      hintStyle: GoogleFonts.krub(color: const Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    final res = await Get.toNamed(AppRoutes.myShopContentForm);
                    if (res == true) {
                      controller.loadContents();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF047857),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'เพิ่มบทความ',
                    style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          // Contents List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget(
                  message: 'กำลังโหลดรายการบทความ...',
                );
              }

              final list = controller.filteredContents;

              if (list.isEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          controller.myShop.value == null
                              ? Icons.storefront_outlined
                              : Icons.article_outlined,
                          size: 64,
                          color: const Color(0xFFCBD5E1),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          controller.myShop.value == null
                              ? 'ยังไม่ได้ลงทะเบียนร้านค้า'
                              : 'ไม่พบบทความหรือเนื้อหาประชาสัมพันธ์',
                          style: GoogleFonts.krub(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.myShop.value == null
                              ? 'กรุณากรอกข้อมูลลงทะเบียนร้านค้าก่อนเริ่มเพิ่มบทความ/ข่าวสาร'
                              : 'คุณสามารถเพิ่มบทความเพื่อแนะนำโปรโมชั่นหรือข่าวสารร้านค้าได้',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.krub(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        if (controller.myShop.value == null) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => Get.toNamed(AppRoutes.registerShop),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.edit_document, size: 18),
                            label: Text(
                              'ลงทะเบียนร้านค้าใหม่',
                              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadContents,
                color: const Color(0xFF047857),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _buildContentCard(context, item);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, ContentModel item) {
    final displayCoverImage = (item.coverImageUrl != null && item.coverImageUrl!.isNotEmpty)
        ? item.coverImageUrl!
        : item.youtubeThumbnail;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Banner
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: const Color(0xFFF1F5F9),
                  child: displayCoverImage.isNotEmpty
                      ? Image.network(
                          displayCoverImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(Icons.broken_image_outlined, color: Color(0xFF94A3B8), size: 40),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.newspaper_rounded, color: Color(0xFFCBD5E1), size: 48),
                        ),
                ),
              ),
              if (item.categoryName != null && item.categoryName!.isNotEmpty)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.categoryName!,
                      style: GoogleFonts.krub(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.krub(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.description != null && item.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.description!,
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      '${item.viewCount} เข้าชม',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const Spacer(),
                    // Actions (Edit & Delete)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Color(0xFF0284C7), size: 20),
                      onPressed: () async {
                        final res = await Get.toNamed(
                          AppRoutes.myShopContentForm,
                          arguments: item,
                        );
                        if (res == true) {
                          controller.loadContents();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE11D48), size: 20),
                      onPressed: () => controller.deleteContent(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
