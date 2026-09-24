import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projecte/features/shops/models/product_model.dart';

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
    final time = remaining == null
        ? null
        : '${remaining.inHours.toString().padLeft(2, '0')}:${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}';

    return SizedBox(
      width: 190,
      child: Material(
        color: Colors.white,
        elevation: 2,
        shadowColor: const Color(0x30000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.toNamed('/products/${product.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 145,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    product.imageUrl?.isNotEmpty == true
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _placeholder(),
                          )
                        : _placeholder(),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEE4D2D),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          discountPercent > 0
                              ? 'ลด $discountPercent%'
                              : deal.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.shopName?.isNotEmpty == true
                            ? product.shopName!
                            : 'ร้านค้าชุมชน',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '฿${product.dealPrice.toStringAsFixed(0)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFEE4D2D),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '฿${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (time != null) ...[
                            const Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: Color(0xFFEE4D2D),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              time,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                fontFeatures: [FontFeature.tabularFigures()],
                                color: Color(0xFFEE4D2D),
                              ),
                            ),
                            const Spacer(),
                          ],
                          Text(
                            'เหลือ ${deal.availableQuantity} ชิ้น',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 34,
                width: double.infinity,
                alignment: Alignment.center,
                color: const Color(0xFFFFF0EB),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ดูสินค้า',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFEE4D2D),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 15,
                      color: Color(0xFFEE4D2D),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => const ColoredBox(
    color: Color(0xFFF5F5F5),
    child: Center(
      child: Icon(
        Icons.shopping_bag_rounded,
        color: Color(0xFFBBBBBB),
        size: 42,
      ),
    ),
  );
}
