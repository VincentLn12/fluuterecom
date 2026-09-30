import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/views/shop_list/shop_list_palette.dart';

class SpecialProductCard extends StatelessWidget {
  const SpecialProductCard({
    super.key,
    required this.product,
    required this.now,
  });

  final ProductModel product;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final deal = product.activeDeal!;
    final discountPercent = product.price > 0
        ? ((product.price - product.dealPrice) / product.price * 100).round()
        : 0;
    final remaining = deal.endsAt?.difference(now);
    final countdown = remaining == null
        ? null
        : '${remaining.inHours.toString().padLeft(2, '0')}:${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      width: 195,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ShopListPalette.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0D2B22),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed('/products/${product.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with badges
              SizedBox(
                height: 136,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _image(),

                    // Discount Ribbon Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              ShopListPalette.orange,
                              ShopListPalette.orangeDark,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33BF4F35),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          discountPercent > 0
                              ? '−$discountPercent%'
                              : deal.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),

                    // Countdown Timer Glass Badge
                    if (countdown != null)
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xCC0D2B22),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 13,
                                color: ShopListPalette.gold,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                countdown,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop name
                      if (product.shopName?.isNotEmpty == true)
                        Row(
                          children: [
                            const Icon(
                              Icons.store_rounded,
                              size: 13,
                              color: ShopListPalette.muted,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                product.shopName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ShopListPalette.muted,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 3),

                      // Product Title
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ShopListPalette.ink,
                          fontSize: 13.5,
                          height: 1.25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const Spacer(),

                      // Price and Buy Arrow
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product.price > product.dealPrice)
                                  Text(
                                    '฿${product.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: ShopListPalette.mutedLight,
                                      fontSize: 11.5,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                Text(
                                  '฿${product.dealPrice.toStringAsFixed(0)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: ShopListPalette.orangeDark,
                                    fontSize: 19,
                                    height: 1.1,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: ShopListPalette.orangeSoft,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: ShopListPalette.orange,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _image() {
    final imageUrl = product.imageUrl;
    if (imageUrl?.isNotEmpty == true) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: ShopListPalette.surfaceMuted,
      child: const Center(
        child: Icon(
          Icons.shopping_bag_rounded,
          color: ShopListPalette.primaryLight,
          size: 36,
        ),
      ),
    );
  }
}
