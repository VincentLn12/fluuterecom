import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/views/shop_list/shop_list_palette.dart';
import 'package:projecte/features/shops/views/shop_list/widgets/special_product_card.dart';

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
          padding: const EdgeInsets.fromLTRB(16, 24, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF4A261),
                            ShopListPalette.orange,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: ShopListPalette.orange.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
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
                          Text(
                            'ดีลพิเศษวันนี้',
                            style: TextStyle(
                              color: ShopListPalette.ink,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'สินค้าชุมชนราคาพิเศษ จำนวนจำกัด',
                            style: TextStyle(
                              color: ShopListPalette.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: ShopListPalette.orangeSoft,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ShopListPalette.orange.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        '${activeProducts.length} ดีลร้อนแรง',
                        style: const TextStyle(
                          color: ShopListPalette.orangeDark,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Horizontal Products List
              SizedBox(
                height: 284,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 16, bottom: 4),
                  itemCount: activeProducts.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => SpecialProductCard(
                    product: activeProducts[index],
                    now: now,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
