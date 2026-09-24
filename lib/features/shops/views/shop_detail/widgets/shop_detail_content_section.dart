import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/contents/models/content_model.dart';

class ShopDetailContentSection extends StatelessWidget {
  final List<ContentModel> contents;

  const ShopDetailContentSection({super.key, required this.contents});

  @override
  Widget build(BuildContext context) {
    if (contents.isEmpty) {
      return const SizedBox.shrink(); // Hide section automatically if no data
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4.5,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A9D8F),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'เรื่องราว & บทความร้านค้า',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D2B22),
                  ),
                ),
              ],
            ),
            Text(
              '${contents.length} เรื่อง',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A7B70),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Horizontal Card Carousel List
        SizedBox(
          height: 230,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: contents.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = contents[index];

              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.contentDetail, arguments: item);
                },
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE0EAE6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner Image
                      SizedBox(
                        height: 130,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildCoverImage(item),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.remove_red_eye_rounded,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${item.viewCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Title & Subtitle
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D2B22),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.menu_book_rounded,
                                  size: 13,
                                  color: Color(0xFF2A9D8F),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'อ่านเรื่องราว',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2A9D8F),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCoverImage(ContentModel item) {
    final hasCover =
        item.coverImageUrl != null && item.coverImageUrl!.isNotEmpty;
    final hasYoutube = item.youtubeThumbnail.isNotEmpty;

    if (hasCover) {
      return Image.network(
        item.coverImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          if (hasYoutube) {
            return Image.network(
              item.youtubeThumbnail,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
            );
          }
          return _buildPlaceholder();
        },
      );
    } else if (hasYoutube) {
      return Image.network(
        item.youtubeThumbnail,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF1B4D3E),
      child: const Center(
        child: Icon(Icons.article_rounded, size: 36, color: Colors.white60),
      ),
    );
  }
}
