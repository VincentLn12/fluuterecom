import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_products_controller.dart';
import '../../../../shops/models/product_model.dart';

class AdminShopProductCard extends StatelessWidget {
  const AdminShopProductCard({
    super.key,
    required this.product,
    required this.controller,
  });

  final ProductModel product;
  final AdminProductsController controller;

  @override
  Widget build(BuildContext context) {
    final isActive = product.status.toLowerCase() == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'ราคา: ฿${product.price.toStringAsFixed(2)} | คลัง: ${product.quantity} ชิ้น',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: isActive,
                activeTrackColor: AppColors.primary,
                onChanged: (_) =>
                    controller.toggleProductStatus(product.id, product.status),
              ),
              Text(
                isActive ? 'วางขายอยู่' : 'ระงับการขาย',
                style: GoogleFonts.krub(
                  fontSize: 10,
                  color: isActive ? AppColors.primary : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
