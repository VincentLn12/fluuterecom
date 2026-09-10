import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'home_section_header.dart';

class HomeHeroSlider extends GetView<HomeController> {
  const HomeHeroSlider({super.key});

  static const Color brandPrimary = Color(0xFFC85A17);
  static const Color cardWhite = Colors.white;
  static const Color borderDark = Color(0xFFD3C7BB);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final banners = controller.heroBanners;
      if (banners.isEmpty) return const SizedBox.shrink();

      return Column(
        children: [
          SizedBox(
            height: 235,
            child: PageView.builder(
              controller: controller.bannerPageController,
              onPageChanged: (idx) => controller.carouselIndex.value = idx,
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final item = banners[index];
                final imageUrl =
                    (item.coverImageUrl != null &&
                        item.coverImageUrl!.isNotEmpty)
                    ? item.coverImageUrl!
                    : item.youtubeThumbnail;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: cardWhite,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: borderDark, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Image
                        Positioned.fill(
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) =>
                                      buildGradientBannerBg(),
                                )
                              : buildGradientBannerBg(),
                        ),

                        // Solid Black Bottom Card Sheet for maximum text readability
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black87,
                                  Colors.black,
                                ],
                                stops: [0.0, 0.45, 1.0],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: brandPrimary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item.categoryName ?? 'ไฮไลท์แนะนำ',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (item.districtName != null &&
                                        item.districtName!.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '📍 ${item.districtName}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.25,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Get.toNamed('/contents/${item.id}'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (index) {
              final isSelected = controller.carouselIndex.value == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isSelected ? 26 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected ? brandPrimary : const Color(0xFF94A3B8),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}
