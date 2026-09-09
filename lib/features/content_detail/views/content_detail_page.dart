import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_detail_controller.dart';
import '../widgets/content_detail_hero.dart';
import '../widgets/content_detail_header.dart';
import '../widgets/content_action_buttons.dart';
import '../widgets/content_summary_card.dart';
import '../widgets/content_schedule_section.dart';
import '../widgets/content_shop_section.dart';
import '../widgets/content_product_section.dart';
import '../widgets/content_review_section.dart';
import '../widgets/related_content_section.dart';
import '../../../shared/widgets/loading_widget.dart';

class ContentDetailPage extends GetView<ContentDetailController> {
  const ContentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F0E6),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF332820),
            size: 19,
          ),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final item = controller.content.value;
          return Text(
            item?.categoryName ?? 'รายละเอียดบทความ',
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF332820),
            ),
          );
        }),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                color: controller.isFavorite.value
                    ? Colors.redAccent
                    : const Color(0xFF332820),
                size: 22,
              ),
              onPressed: controller.toggleFavorite,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.share_rounded,
              color: Color(0xFF332820),
              size: 21,
            ),
            onPressed: controller.shareContent,
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Color(0xFF332820),
              size: 22,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (value) {
              if (value == 'report') {
                _showReportDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      color: Colors.redAccent,
                      size: 19,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'รายงานบทความนี้',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        if (controller.isError.value) {
          return _buildErrorState();
        }

        final item = controller.content.value;
        if (item == null) {
          return _buildErrorState();
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Hero Video Card (Standard 16:9 Aspect Ratio like old version)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: ContentDetailHero(item: item),
              ),

              // Module Components
              ContentDetailHeader(item: item),
              const ContentActionButtons(),
              ContentSummaryCard(item: item),
              const ContentScheduleSection(),
              const ContentShopSection(),
              const ContentProductSection(),
              const ContentReviewSection(),
              const RelatedContentSection(),
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }



  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : 'เกิดข้อผิดพลาดในการโหลดข้อมูล',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF332820),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: controller.retry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD96C2C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'ลองใหม่อีกครั้ง',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.flag_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text(
              'แจ้งรายงานเนื้อหา',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'โปรดระบุสาเหตุที่คุณต้องการรายงานบทความนี้:',
              style: TextStyle(fontSize: 14, color: Color(0xFF554438)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'เช่น เนื้อหาไม่ถูกต้อง, สแปม, ข้อมูลเท็จ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isNotEmpty) {
                controller.reportContent(reason);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('ส่งรายงาน'),
          ),
        ],
      ),
    );
  }
}

