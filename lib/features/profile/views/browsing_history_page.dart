import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/browsing_history_controller.dart';
import '../models/content_view_history_model.dart';

import '../../../shared/widgets/loading_widget.dart';

class BrowsingHistoryPage extends GetView<BrowsingHistoryController> {
  const BrowsingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BrowsingHistoryController>()) {
      Get.put(BrowsingHistoryController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'ประวัติการเข้าชม',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'รีเฟรช',
            onPressed: () => controller.fetchHistory(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.historyList.isEmpty) {
          return const LoadingWidget(
            message: 'กำลังโหลดประวัติการเข้าชม...',
            icon: Icons.history_rounded,
          );
        }

        if (controller.historyList.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: const Color(0xFFD96C2C),
          onRefresh: controller.refreshHistory,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            itemCount: controller.historyList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.historyList[index];
              return _buildHistoryCard(context, item);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFD96C2C).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 48,
                color: Color(0xFFD96C2C),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'ยังไม่มีประวัติการเข้าชม',
              style: GoogleFonts.krub(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF332820),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'เมื่อคุณเข้าชมเรื่องราวหรือบทความต่างๆ รายการที่คุณดูจะถูกบันทึกไว้ที่นี่',
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 13.5,
                color: const Color(0xFF786B62),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.contents),
              icon: const Icon(Icons.explore_outlined, size: 18),
              label: Text(
                'สำรวจเรื่องน่าสนใจ',
                style: GoogleFonts.krub(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD96C2C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, ContentViewHistoryModel item) {
    final imageUri = item.displayImage;
    final hasImage = imageUri.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (item.contentId.isNotEmpty) {
            Get.toNamed('/contents/${item.contentId}');
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8D9C9), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image / Video Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 90,
                  height: 90,
                  color: const Color(0xFFE8D9C9),
                  child: Stack(
                    children: [
                      if (hasImage)
                        Image.network(
                          imageUri,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                        )
                      else
                        _buildPlaceholderImage(),
                      if (item.youtubeUrl != null && item.youtubeUrl!.isNotEmpty)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.25),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Detail
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.krub(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF332820),
                        height: 1.3,
                      ),
                    ),
                    if (item.summary != null && item.summary!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.summary!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: const Color(0xFF786B62),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: Color(0xFFD96C2C),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.formattedViewedAt.isNotEmpty
                              ? item.formattedViewedAt
                              : 'เข้าชมแล้ว',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD96C2C),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: Color(0xFF786B62),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.article_outlined,
            color: Color(0xFF786B62),
            size: 28,
          ),
          const SizedBox(height: 2),
          Text(
            'ไม่มีรูป',
            style: GoogleFonts.krub(
              fontSize: 10,
              color: const Color(0xFF786B62),
            ),
          ),
        ],
      ),
    );
  }
}
