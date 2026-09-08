import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_detail_controller.dart';
import '../widgets/content_video_player.dart';
import '../widgets/content_map_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/empty_widget.dart';

class ContentDetailPage extends GetView<ContentDetailController> {
  const ContentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF332820),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Text(
              controller.content.value?.title ?? 'รายละเอียดบทความ',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Get.snackbar('แชร์เนื้อหา', 'คัดลอกลิงก์เนื้อหาเรียบร้อย');
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {
              Get.snackbar('บันทึก', 'บันทึกบทความในรายการโปรดแล้ว');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        final item = controller.content.value;
        if (item == null) {
          return const EmptyWidget(message: 'ไม่พบเนื้อหาบทความ');
        }

        final hasVideo = item.youtubeUrl != null && item.youtubeUrl!.trim().isNotEmpty;
        final coverImg = item.coverImageUrl ?? (item.youtubeThumbnail.isNotEmpty ? item.youtubeThumbnail : null);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP MEDIA: Video Player if available (autoPlay: true), replacing header image
              if (hasVideo)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: ContentVideoPlayer(
                    videoUrl: item.youtubeUrl!,
                    autoPlay: true,
                  ),
                )
              else if (coverImg != null && coverImg.isNotEmpty)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    coverImg,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildHeaderPlaceholder(),
                  ),
                )
              else
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _buildHeaderPlaceholder(),
                ),

              // Content Body Article
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges & Meta
                    Row(
                      children: [
                        if (item.categoryName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD96C2C),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.categoryName!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (item.districtName != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF332820),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, size: 13, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  item.districtName!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF332820),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Rating & Stats
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Color(0xFFE9C46A)),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.visibility_outlined, size: 18, color: Colors.grey[700]),
                        const SizedBox(width: 4),
                        Text(
                          '${item.viewCount} เข้าชม',
                          style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                      ],
                    ),
                    const Divider(height: 32, color: Color(0xFFE8D9C9)),

                    // Description / Summary Callout Box
                    if (item.description != null && item.description!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9F2),
                          borderRadius: BorderRadius.circular(16),
                          border: const Border(
                            left: BorderSide(color: Color(0xFFD96C2C), width: 4.5),
                          ),
                        ),
                        child: Text(
                          item.description!,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF332820),
                            height: 1.55,
                          ),
                        ),
                      ),
                    const SizedBox(height: 22),

                    // Main Text Body
                    Text(
                      item.body ?? item.description ?? 'ไม่มีรายละเอียดเนื้อหาเพิ่มเติม',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xFF332820),
                        height: 1.75,
                      ),
                    ),
                    const SizedBox(height: 26),

                    // Map & Directions Section
                    if (item.latitude != null && item.longitude != null) ...[
                      ContentMapWidget(
                        latitude: item.latitude,
                        longitude: item.longitude,
                        title: item.title,
                        shopName: item.shopName,
                        districtName: item.districtName,
                      ),
                      const SizedBox(height: 26),
                    ],

                    // Tags
                    if (item.tags.isNotEmpty) ...[
                      const Text(
                        'แท็กที่เกี่ยวข้อง:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item.tags.map((tag) {
                          return Chip(
                            label: Text('#$tag'),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFE8D9C9)),
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFD96C2C),
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD96C2C), Color(0xFF171412)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.travel_explore, size: 60, color: Colors.white54),
      ),
    );
  }
}
