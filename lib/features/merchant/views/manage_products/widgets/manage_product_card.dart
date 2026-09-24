import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/merchant/controllers/manage_products_controller.dart';

String formatCurrency(double amount) {
  final str = amount.toStringAsFixed(2);
  final parts = str.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
  return '฿$intPart';
}

class ManageProductCard extends StatelessWidget {
  const ManageProductCard({
    super.key,
    required this.controller,
    required this.product,
  });

  final ManageProductsController controller;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.quantity <= 5 && product.quantity > 0;
    final isOutOfStock = product.quantity <= 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isOutOfStock
              ? const Color(0xFFFECDD3)
              : isLowStock
              ? const Color(0xFFFDE68A)
              : const Color(0xFFCBD5E1),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Thumbnail Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                    (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                    ? Image.network(
                        product.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFFF1F5F9),
                          child: const Icon(
                            Icons.broken_image_rounded,
                            color: Color(0xFF94A3B8),
                            size: 32,
                          ),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: const Color(0xFFECFDF5),
                        child: const Icon(
                          Icons.inventory_2_rounded,
                          color: Color(0xFF059669),
                          size: 36,
                        ),
                      ),
              ),
              if (isOutOfStock)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'หมด',
                        style: GoogleFonts.krub(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.krub(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Price Tag
                Text(
                  formatCurrency(product.price),
                  style: GoogleFonts.krub(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF047857),
                  ),
                ),
                const SizedBox(height: 6),

                // Badges Row (Stock & Status)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildStockBadge(product.quantity),
                    _buildStatusBadge(product.status),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Action Buttons (Edit & Delete)
          Column(
            children: [
              InkWell(
                onTap: () async {
                  final result = await Get.toNamed(
                    AppRoutes.myShopProductForm,
                    arguments: product,
                  );
                  if (result == true) controller.loadProducts();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'แก้ไข',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => Get.toNamed(
                  AppRoutes.myShopProductDeals,
                  arguments: product,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFB74D)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 14,
                        color: Color(0xFFE65100),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'โปรโมชัน',
                        style: GoogleFonts.krub(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE65100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => controller.confirmDeleteProduct(product),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFECDD3)),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFE11D48),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockBadge(int quantity) {
    Color bg = const Color(0xFFECFDF5);
    Color fg = const Color(0xFF047857);
    String text = 'คงเหลือ: $quantity ชิ้น';

    if (quantity <= 0) {
      bg = const Color(0xFFFFE4E6);
      fg = const Color(0xFFE11D48);
      text = 'หมดสต็อก';
    } else if (quantity <= 5) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFD97706);
      text = 'สต็อกต่ำ ($quantity)';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.krub(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status == 'Active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF047857) : const Color(0xFF64748B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? 'วางขายอยู่' : 'ปิดการขาย',
        style: GoogleFonts.krub(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
