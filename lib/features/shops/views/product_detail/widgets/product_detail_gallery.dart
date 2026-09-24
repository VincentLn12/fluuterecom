import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/shops/controllers/product_detail_controller.dart';
import 'package:projecte/features/shops/models/product_model.dart';

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
            color: const Color(0xFFF2F2F2),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: currentImage != null
                        ? Image.network(
                            currentImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),

                  // Back button
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.94),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: Get.back,
                        child: const Padding(
                          padding: EdgeInsets.all(9),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF262626),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Favorite button
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Obx(
                      () => Material(
                        color: Colors.white.withValues(alpha: 0.94),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: controller.toggleFavorite,
                          child: Padding(
                            padding: const EdgeInsets.all(9),
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

                  // Image counter
                  if (images.length > 1)
                    Positioned(
                      bottom: 10,
                      right: 12,
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

        // Page dots
        if (images.length > 1) ...[
          const SizedBox(height: 10),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final selected = controller.selectedImageIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.selectImage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: selected ? 16 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFEE4D2D)
                          : const Color(0xFFD3D3D3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
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
