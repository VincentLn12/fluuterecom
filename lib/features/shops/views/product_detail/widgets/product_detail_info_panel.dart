import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/shops/controllers/product_detail_controller.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/models/shop_model.dart';

class ProductDetailInfoPanel extends GetView<ProductDetailController> {
  const ProductDetailInfoPanel({super.key, required this.product, this.shop});

  final ProductModel product;
  final ShopModel? shop;

  @override
  Widget build(BuildContext context) {
    final deal = product.activeDeal;
    final hasDeal =
        deal != null && !deal.isExpired && deal.availableQuantity > 0;
    final inStock = product.quantity > 0;
    final discount = product.price <= 0
        ? 0
        : ((product.price - product.dealPrice) / product.price * 100).round();
    final reviews = controller.shopReviews;
    final averageRating = reviews.isEmpty
        ? 0.0
        : reviews.fold<double>(0, (sum, review) => sum + review.rating) /
              reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shop?.categoryName?.isNotEmpty == true
              ? 'OTOP  •  ${shop!.categoryName}'
              : 'OTOP  •  ของฝากชุมชน',
          style: GoogleFonts.krub(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF8A5B3D),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          product.name,
          style: GoogleFonts.krub(
            fontSize: 21,
            height: 1.3,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF202124),
          ),
        ),
        const SizedBox(height: 8),
        if (reviews.isNotEmpty)
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 17,
                color: Color(0xFFFFA000),
              ),
              const SizedBox(width: 3),
              Text(
                averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${reviews.length} รีวิว)',
                style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
              ),
            ],
          ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                '฿${(hasDeal ? product.dealPrice : product.price).toStringAsFixed(0)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.krub(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFEE4D2D),
                ),
              ),
            ),
            if (hasDeal) ...[
              const SizedBox(width: 8),
              Text(
                '฿${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9E3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-$discount%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFEE4D2D),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              inStock ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 15,
              color: inStock
                  ? const Color(0xFF2E8B57)
                  : const Color(0xFFB42318),
            ),
            const SizedBox(width: 5),
            Text(
              inStock ? 'มีสินค้า' : 'สินค้าหมด',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: inStock
                    ? const Color(0xFF387A51)
                    : const Color(0xFFB42318),
              ),
            ),
            if (inStock) ...[
              const SizedBox(width: 5),
              Text(
                '• ${product.quantity} ชิ้น',
                style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
