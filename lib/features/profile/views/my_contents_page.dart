import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../contents/models/content_model.dart';
import '../controllers/my_contents_controller.dart';

import '../../../shared/widgets/loading_widget.dart';

class MyContentsPage extends StatelessWidget {
  const MyContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyContentsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'กิจกรรมและคอนเทนต์ของคุณ',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'รีเฟรชข้อมูล',
            onPressed: () => controller.fetchMyContents(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(
            message: 'กำลังโหลดคอนเทนต์ของคุณ...',
            icon: Icons.article_rounded,
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFD96C2C),
          onRefresh: () => controller.fetchMyContents(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero CTA Banner
                _buildHeroHeader(context),

                const SizedBox(height: 18),

                // 2. Filter Bar
                _buildFilterChips(controller),

                const SizedBox(height: 18),

                // 3. Content List or Empty State
                controller.filteredContents.isEmpty
                    ? _buildEmptyState(context, controller)
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.filteredContents.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final content = controller.filteredContents[index];
                          return _buildContentCard(
                            context,
                            controller,
                            content,
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.article_outlined,
                  color: Color(0xFFD96C2C),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'เรื่องราวและคอนเทนต์ของคุณ',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: const Color(0xFF332820),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'เรื่องราว บทความท่องเที่ยว และกิจกรรมชุมชนที่คุณได้เขียนและแบ่งปันบนแพลตฟอร์ม',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        color: const Color(0xFF786B62),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _handleCreateNewContent(),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              label: Text(
                'สร้างคอนเทนต์ใหม่',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD96C2C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(MyContentsController controller) {
    final filters = [
      {'key': 'all', 'label': 'ทั้งหมด'},
      {'key': 'published', 'label': 'เผยแพร่แล้ว'},
      {'key': 'pending', 'label': 'รอตรวจสอบ'},
      {'key': 'archived', 'label': 'เก็บถาวร'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = controller.selectedFilter.value == f['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                f['label']!,
                style: GoogleFonts.krub(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                  color: isSelected ? Colors.white : const Color(0xFF786B62),
                ),
              ),
              selected: isSelected,
              selectedColor: const Color(0xFFD96C2C),
              backgroundColor: const Color(0xFFFFF9F2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFFD96C2C)
                      : const Color(0xFFE8D9C9),
                ),
              ),
              onSelected: (_) => controller.setFilter(f['key']!),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContentCard(
    BuildContext context,
    MyContentsController controller,
    ContentModel content,
  ) {
    final imageUrl = content.coverImageUrl?.isNotEmpty == true
        ? content.coverImageUrl!
        : (content.youtubeThumbnail.isNotEmpty
              ? content.youtubeThumbnail
              : null);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Thumbnail Image & Status Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  color: const Color(0xFFE8D9C9).withValues(alpha: 0.5),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImageFallback(),
                        )
                      : _buildImageFallback(),
                ),
              ),
              // Status Badge (Published, Pending, Archived)
              Positioned(
                top: 12,
                left: 12,
                child: _buildStatusBadge(content.status),
              ),
              // Category Chip
              if (content.categoryName != null &&
                  content.categoryName!.isNotEmpty)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      content.categoryName!,
                      style: GoogleFonts.krub(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // 2. Details Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF332820),
                    height: 1.3,
                  ),
                ),
                if (content.description != null &&
                    content.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    content.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      color: const Color(0xFF786B62),
                      height: 1.35,
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // Meta info row (District, Date, Views)
                Row(
                  children: [
                    if (content.districtName != null &&
                        content.districtName!.isNotEmpty) ...[
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFFD96C2C),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        content.districtName!,
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: const Color(0xFF786B62),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    const Icon(
                      Icons.visibility_outlined,
                      size: 14,
                      color: Color(0xFF786B62),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${content.viewCount} เข้าชม',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        color: const Color(0xFF786B62),
                      ),
                    ),
                    const Spacer(),
                    if (content.publishedAt != null)
                      Text(
                        _formatDate(content.publishedAt!),
                        style: GoogleFonts.krub(
                          fontSize: 11,
                          color: const Color(0xFF786B62),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFE8D9C9)),
                const SizedBox(height: 10),

                // 3. Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // View details button
                    OutlinedButton.icon(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.contentDetail.replaceAll(':id', content.id),
                        );
                      },
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                      label: Text(
                        'ดูคอนเทนต์',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF332820),
                        side: const BorderSide(color: Color(0xFFE8D9C9)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        // Edit Button
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Color(0xFFD96C2C),
                          ),
                          tooltip: 'แก้ไข',
                          onPressed: () {
                            Get.toNamed(
                              AppRoutes.createContent,
                              arguments: content,
                            );
                          },
                        ),
                        // Archive / Delete Button
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                            color: Colors.redAccent,
                          ),
                          tooltip: 'จัดเก็บถาวร',
                          onPressed: () => controller.archiveContent(content),
                        ),
                      ],
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

  Widget _buildStatusBadge(String? status) {
    final s = status?.toLowerCase() ?? 'published';
    Color bg;
    String label;
    IconData icon;

    if (s == 'pending') {
      bg = const Color(0xFFF59E0B);
      label = 'รอตรวจสอบ';
      icon = Icons.hourglass_empty_rounded;
    } else if (s == 'archived' || s == 'draft') {
      bg = const Color(0xFF8D7B68);
      label = 'เก็บถาวร';
      icon = Icons.archive_outlined;
    } else {
      bg = const Color(0xFF059669);
      label = 'เผยแพร่แล้ว';
      icon = Icons.check_circle_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.krub(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: const Color(0xFFE8D9C9).withValues(alpha: 0.4),
      child: const Center(
        child: Icon(
          Icons.photo_library_outlined,
          color: Color(0xFF786B62),
          size: 40,
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    MyContentsController controller,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8D9C9).withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.article_outlined,
              size: 48,
              color: Color(0xFF786B62),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ไม่พบรายการคอนเทนต์',
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: const Color(0xFF332820),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'คุณยังไม่มีบทความหรือกิจกรรมในหมวดหมู่นี้ เริ่มต้นสร้างคอนเทนต์เพื่อแบ่งปันเรื่องราวเมืองกาญจน์กันเลย!',
            textAlign: TextAlign.center,
            style: GoogleFonts.krub(
              fontSize: 13,
              color: const Color(0xFF786B62),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _handleCreateNewContent(),
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              'สร้างคอนเทนต์แรกของคุณ',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD96C2C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCreateNewContent() {
    Get.toNamed(AppRoutes.createContent);
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      const months = [
        'ม.ค.',
        'ก.พ.',
        'มี.ค.',
        'เม.ย.',
        'พ.ค.',
        'มิ.ย.',
        'ก.ค.',
        'ส.ค.',
        'ก.ย.',
        'ต.ค.',
        'พ.ย.',
        'ธ.ค.',
      ];
      final monthName = months[dt.month - 1];
      final yearThai = dt.year + 543;
      return '${dt.day} $monthName $yearThai';
    } catch (_) {
      return isoDate;
    }
  }
}
