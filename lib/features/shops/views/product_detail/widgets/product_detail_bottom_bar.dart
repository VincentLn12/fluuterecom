import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/shops/controllers/product_detail_controller.dart';

class ProductDetailBottomBar extends GetView<ProductDetailController> {
  const ProductDetailBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = controller.product.value;
      if (product == null) return const SizedBox.shrink();

      final inStock = product.quantity > 0;
      return Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFE8E4DF))),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF332820).withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Obx(
                () => IconButton(
                  tooltip: 'เพิ่มรายการโปรด',
                  onPressed: controller.toggleFavorite,
                  icon: Icon(
                    controller.isFavorite.value
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: const Color(0xFFEE4D2D),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Quick Add To Cart Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: inStock ? controller.addToCart : null,
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                  label: Text(
                    'ใส่ตะกร้า',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEE4D2D),
                    side: const BorderSide(color: Color(0xFFEE4D2D)),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Buy Now Button
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  onPressed: inStock ? controller.buyNow : null,
                  icon: const Icon(Icons.bolt_rounded, size: 18),
                  label: Text(
                    inStock ? 'ซื้อเลย' : 'สินค้าหมด',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE4D2D),
                    disabledBackgroundColor: Colors.grey[400],
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
