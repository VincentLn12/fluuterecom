import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/content_detail_controller.dart';

class ContentActionButtons extends GetView<ContentDetailController> {
  const ContentActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          // Directions Button (Primary Action)
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD96C2C), Color(0xFFED8936)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD96C2C).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: controller.openGoogleMaps,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.near_me_rounded, size: 19),
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'นำทางไปยังสถานที่ 📍',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Favorite Button
          Obx(
            () => SizedBox(
              height: 48,
              width: 50,
              child: ElevatedButton(
                onPressed: controller.toggleFavorite,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isFavorite.value
                      ? const Color(0xFFFFECE0)
                      : Colors.white,
                  foregroundColor: controller.isFavorite.value
                      ? const Color(0xFFD96C2C)
                      : const Color(0xFF554438),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: controller.isFavorite.value
                          ? const Color(0xFFD96C2C)
                          : const Color(0xFFEADCCF),
                      width: 1.5,
                    ),
                  ),
                ),
                child: Icon(
                  controller.isFavorite.value
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  color: controller.isFavorite.value
                      ? const Color(0xFFD96C2C)
                      : const Color(0xFF554438),
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Share Button
          SizedBox(
            height: 48,
            width: 50,
            child: ElevatedButton(
              onPressed: controller.shareContent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF554438),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: Color(0xFFEADCCF),
                    width: 1.5,
                  ),
                ),
              ),
              child: const Icon(Icons.share_outlined, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

