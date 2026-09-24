import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projecte/features/shops/models/product_model.dart';

import 'special_product_card.dart';

class ShopFlashSaleSection extends StatelessWidget {
  const ShopFlashSaleSection({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (tick) => tick,
      ),
      builder: (context, snapshot) {
        final now = DateTime.now().toUtc();

        final activeProducts = products.where((product) {
          final deal = product.activeDeal;

          return product.quantity > 0 &&
              deal != null &&
              deal.availableQuantity > 0 &&
              (deal.endsAt == null || deal.endsAt!.isAfter(now));
        }).toList();

        if (activeProducts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FlashSaleHeader(
                dealCount: activeProducts.length,
              ),

              const SizedBox(height: 4),

              SizedBox(
                height: 315,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    10,
                    16,
                    18,
                  ),
                  itemCount: activeProducts.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    return SpecialProductCard(
                      product: activeProducts[index],
                      now: now,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FlashSaleHeader extends StatelessWidget {
  const _FlashSaleHeader({
    required this.dealCount,
  });

  final int dealCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        14,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFF4EF),
            Color(0xFFFFFFFF),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF97316),
                  Color(0xFFEA580C),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF97316)
                      .withValues(alpha: 0.22),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Flash Sale',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F382C),
                        height: 1.1,
                      ),
                    ),
                    SizedBox(width: 7),
                    Text(
                      '⚡',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'ดีลพิเศษจากร้านค้าชุมชน',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6B7F76),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEE7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$dealCount ดีล',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFFEA580C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}