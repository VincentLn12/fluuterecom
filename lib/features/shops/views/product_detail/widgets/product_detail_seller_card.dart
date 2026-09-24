import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/shops/models/shop_model.dart';

class ProductDetailSellerCard extends StatelessWidget {
  const ProductDetailSellerCard({super.key, required this.shop});

  final ShopModel shop;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.toNamed(AppRoutes.shopDetail, arguments: shop),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE9E9E9)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: const Color(0xFFFFF0EB),
                backgroundImage: shop.coverImageUrl?.isNotEmpty == true
                    ? NetworkImage(shop.coverImageUrl!)
                    : null,
                child: shop.coverImageUrl?.isNotEmpty == true
                    ? null
                    : const Icon(
                        Icons.storefront_rounded,
                        color: Color(0xFFEE4D2D),
                      ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF252525),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      shop.categoryName?.isNotEmpty == true
                          ? shop.categoryName!
                          : 'สินค้าชุมชน',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'ดูร้านค้า',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEE4D2D),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Color(0xFFEE4D2D),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
