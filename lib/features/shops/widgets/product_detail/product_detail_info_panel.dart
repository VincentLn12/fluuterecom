import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../controllers/product_detail_controller.dart';
import '../../models/product_model.dart';
import '../../models/shop_model.dart';

class ProductDetailInfoPanel extends GetView<ProductDetailController> {
  final ProductModel product;
  final ShopModel? shop;

  const ProductDetailInfoPanel({super.key, required this.product, this.shop});

  @override
  Widget build(BuildContext context) {
    final inStock = product.quantity > 0;
    final reviews = controller.shopReviews;

    // Real review stats computation
    final double avgRating = reviews.isNotEmpty
        ? (reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length)
        : 5.0;
    final int reviewCount = reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Tag Pill
        if (shop?.categoryName != null && shop!.categoryName!.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFD96C2C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD96C2C).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_offer_outlined,
                  size: 13,
                  color: Color(0xFFD96C2C),
                ),
                const SizedBox(width: 4),
                Text(
                  shop!.categoryName!,
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
              ],
            ),
          ),

        // Product Name
        Text(
          product.name,
          style: GoogleFonts.krub(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF332820),
            height: 1.25,
          ),
        ),

        const SizedBox(height: 10),

        // Seller Link Box
        if (shop != null) ...[
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.shopDetail, arguments: shop),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F0E6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8D9C9)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        shop!.coverImageUrl != null &&
                            shop!.coverImageUrl!.isNotEmpty
                        ? NetworkImage(shop!.coverImageUrl!)
                        : null,
                    child:
                        shop!.coverImageUrl == null ||
                            shop!.coverImageUrl!.isEmpty
                        ? const Icon(
                            Icons.storefront_rounded,
                            size: 14,
                            color: Color(0xFFD96C2C),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    shop!.name,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD96C2C),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFFD96C2C),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],

        // Rating & Reviews Status Bar (Real Data)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: Color(0xFFE8D9C9)),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFD96C2C).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 15,
                      color: Color(0xFFD96C2C),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      reviewCount > 0
                          ? '${avgRating.toStringAsFixed(1)} ($reviewCount รีวิว)'
                          : 'ไม่มีรีวิว',
                      style: GoogleFonts.krub(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD96C2C),
                      ),
                    ),
                  ],
                ),
              ),
              if (shop?.districtName != null &&
                  shop!.districtName!.isNotEmpty) ...[
                const SizedBox(width: 10),
                const Text('•', style: TextStyle(color: Color(0xFFE8D9C9))),
                const SizedBox(width: 10),
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 2),
                Text(
                  shop!.districtName!,
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF786B62),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Price Display Box (Mobile Optimized)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFD96C2C).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFD96C2C).withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ราคาขาย',
                    style: GoogleFonts.krub(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF786B62),
                    ),
                  ),
                  Text(
                    '฿${product.price.toStringAsFixed(0)}',
                    style: GoogleFonts.krub(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFD96C2C),
                    ),
                  ),
                ],
              ),

              // Stock Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFD96C2C).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: inStock
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      inStock ? 'สต็อก ${product.quantity} ชิ้น' : 'สินค้าหมด',
                      style: GoogleFonts.krub(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD96C2C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Quantity Selector Row
        Row(
          children: [
            Text(
              'จำนวนที่ต้องการ:',
              style: GoogleFonts.krub(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF332820),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F0E6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8D9C9), width: 1.2),
              ),
              child: Row(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.remove_rounded, size: 16),
                    color: const Color(0xFF332820),
                    onPressed: controller.decrementQuantity,
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${controller.quantity.value}',
                        style: GoogleFonts.krub(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF332820),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    final isAtMax =
                        controller.quantity.value >= product.quantity;
                    return IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.add_rounded, size: 16),
                      color: isAtMax
                          ? Colors.grey[400]
                          : const Color(0xFF332820),
                      onPressed: isAtMax ? null : controller.incrementQuantity,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Action CTA Buttons: Add to Cart & Buy Now
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: inStock ? controller.addToCart : null,
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                label: Text(
                  'เพิ่มลงตะกร้า',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD96C2C),
                  side: const BorderSide(color: Color(0xFFD96C2C), width: 1.8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: inStock ? controller.buyNow : null,
                icon: const Icon(
                  Icons.bolt_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  'สั่งซื้อทันที',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
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

        const SizedBox(height: 16),

        // 3 Guarantee Badges
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F0E6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8D9C9)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGuaranteeBadge(
                icon: Icons.verified_user_outlined,
                title: 'ชำระเงินปลอดภัย',
                subtitle: 'ระบบมาตรฐาน',
              ),
              _buildGuaranteeBadge(
                icon: Icons.local_shipping_outlined,
                title: 'จัดส่งรวดเร็ว',
                subtitle: '1-3 วันทำการ',
              ),
              _buildGuaranteeBadge(
                icon: Icons.sync_rounded,
                title: 'คืนสินค้าได้',
                subtitle: 'ภายใน 7 วัน',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuaranteeBadge({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFD96C2C), size: 20),
        const SizedBox(height: 2),
        Text(
          title,
          style: GoogleFonts.krub(
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF332820),
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.krub(
            fontSize: 8.5,
            color: const Color(0xFF786B62),
          ),
        ),
      ],
    );
  }
}
