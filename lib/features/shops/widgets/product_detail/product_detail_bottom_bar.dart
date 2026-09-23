import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/product_detail_controller.dart';

class ProductDetailBottomBar extends GetView<ProductDetailController> {
  const ProductDetailBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = controller.product.value;
      if (product == null) return const SizedBox.shrink();

      final inStock = product.quantity > 0;
      final deal = product.activeDeal;
      final hasActiveDeal =
          deal != null && !deal.isExpired && deal.availableQuantity > 0;
      final unitPrice = hasActiveDeal ? product.dealPrice : product.price;
      final subtotal = unitPrice * controller.quantity.value;

      return Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF332820).withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
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
                    foregroundColor: const Color(0xFFD96C2C),
                    side: const BorderSide(
                      color: Color(0xFFD96C2C),
                      width: 1.8,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
                  icon: const Icon(
                    Icons.bolt_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: Text(
                    inStock
                        ? 'ซื้อเลย • ฿${subtotal.toStringAsFixed(0)}'
                        : 'สินค้าหมด',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD96C2C),
                    disabledBackgroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
