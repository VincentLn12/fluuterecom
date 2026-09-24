import 'dart:async';

import 'package:flutter/material.dart';

import 'package:projecte/features/shops/models/product_model.dart';
import 'special_product_card.dart';

class ShopFlashSaleSection extends StatelessWidget {
  const ShopFlashSaleSection({super.key, required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (tick) => tick),
      builder: (context, snapshot) {
        final now = DateTime.now().toUtc();
        final activeProducts = products.where((product) {
          final deal = product.activeDeal;
          return product.quantity > 0 &&
              deal != null &&
              deal.availableQuantity > 0 &&
              (deal.endsAt == null || deal.endsAt!.isAfter(now));
        }).toList();
        if (activeProducts.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.flash_on_rounded,
                        color: Color(0xFFEE4D2D),
                        size: 22,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'โปรโมชั่นพิเศษ',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFEE4D2D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF1F1F1)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 310,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    itemCount: activeProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 14),
                    itemBuilder: (_, index) => SpecialProductCard(
                      product: activeProducts[index],
                      now: now,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
