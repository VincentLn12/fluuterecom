import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../models/product_model.dart';

class ProductDetailOtherProducts extends StatelessWidget {
  final String title;
  final String? shopId;
  final List<ProductModel> products;

  const ProductDetailOtherProducts({
    super.key,
    required this.title,
    this.shopId,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (shopId != null) {
                    Get.toNamed(AppRoutes.shopDetail, arguments: shopId);
                  } else {
                    Get.toNamed(AppRoutes.shops);
                  }
                },
                child: Text(
                  'ดูทั้งหมด >',
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFE8D9C9)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return _buildMiniProductCard(p);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniProductCard(ProductModel p) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.productDetail,
          arguments: p,
          preventDuplicates: false,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8D9C9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: p.imageUrl != null && p.imageUrl!.trim().isNotEmpty
                    ? Image.network(
                        p.imageUrl!.trim(),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF332820),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '฿${p.price.toStringAsFixed(0)}',
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFD96C2C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF171412),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 32,
          color: Colors.white30,
        ),
      ),
    );
  }
}
