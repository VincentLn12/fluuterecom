import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/product_detail_controller.dart';
import '../../models/product_model.dart';

class ProductDetailGallery extends GetView<ProductDetailController> {
  final ProductModel product;
  final List<String> images;

  const ProductDetailGallery({
    super.key,
    required this.product,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Preview Image Frame
        Obx(() {
          final selectedIdx = controller.selectedImageIndex.value;
          final hasImages = images.isNotEmpty;
          final currentImage = hasImages && selectedIdx < images.length
              ? images[selectedIdx]
              : null;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF171412),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: currentImage != null
                        ? Image.network(
                            currentImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),

                  // Top Left Status Badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD96C2C),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        '✨ สินค้าแนะนำ',
                        style: GoogleFonts.krub(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Top Right Favorite Button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Obx(
                      () => Material(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: const CircleBorder(),
                        elevation: 3,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: controller.toggleFavorite,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              controller.isFavorite.value
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: controller.isFavorite.value
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFFD96C2C),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Gallery Prev / Next Arrows
                  if (images.length > 1) ...[
                    Positioned(
                      left: 6,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.85),
                          radius: 16,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Color(0xFF332820),
                              size: 20,
                            ),
                            onPressed: () {
                              int prev =
                                  (selectedIdx - 1 + images.length) %
                                  images.length;
                              controller.selectImage(prev);
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 6,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.85),
                          radius: 16,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF332820),
                              size: 20,
                            ),
                            onPressed: () {
                              int next = (selectedIdx + 1) % images.length;
                              controller.selectImage(next);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Bottom Image Indicator
                  if (images.length > 1)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${selectedIdx + 1} / ${images.length}',
                          style: GoogleFonts.krub(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),

        // Thumbnails Strip
        if (images.length > 1) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final isSelected =
                      controller.selectedImageIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.selectImage(index),
                    child: Container(
                      width: 56,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFD96C2C)
                              : const Color(0xFFE8D9C9),
                          width: isSelected ? 2.2 : 1.2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImagePlaceholder(),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF171412),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 32,
          color: Colors.white30,
        ),
      ),
    );
  }
}
