import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import '../../models/shop_model.dart';

class ProductDetailSellerCard extends StatelessWidget {
  final ShopModel shop;

  const ProductDetailSellerCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final hasPhone = shop.phone != null && shop.phone!.trim().isNotEmpty;
    final hasHours = shop.openingTime != null && shop.closingTime != null;
    final hasAddr = shop.address != null && shop.address!.trim().isNotEmpty;

    return Container(
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
            children: [
              const Icon(
                Icons.storefront_rounded,
                color: Color(0xFFD96C2C),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'ร้านผู้จำหน่าย',
                style: GoogleFonts.krub(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFE8D9C9)),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(
                  0xFFD96C2C,
                ).withValues(alpha: 0.2),
                backgroundImage:
                    shop.coverImageUrl != null && shop.coverImageUrl!.isNotEmpty
                        ? NetworkImage(shop.coverImageUrl!)
                        : null,
                child:
                    shop.coverImageUrl == null || shop.coverImageUrl!.isEmpty
                        ? const Icon(
                          Icons.storefront_rounded,
                          color: Color(0xFFD96C2C),
                          size: 22,
                        )
                        : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            shop.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.krub(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF332820),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 15,
                          color: Color(0xFFD96C2C),
                        ),
                      ],
                    ),
                    Text(
                      '${shop.categoryName ?? 'ร้านค้าชุมชน'} • ${shop.districtName ?? 'กาญจนบุรี'}',
                      style: GoogleFonts.krub(
                        fontSize: 11.5,
                        color: const Color(0xFF786B62),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasPhone || hasHours || hasAddr) ...[
            const SizedBox(height: 12),
            if (hasPhone) ...[
              _buildInfoRow(Icons.phone_outlined, shop.phone!),
              const SizedBox(height: 5),
            ],
            if (hasHours) ...[
              _buildInfoRow(
                Icons.access_time_rounded,
                'เปิด ${shop.openingTime} - ${shop.closingTime} น.',
              ),
              const SizedBox(height: 5),
            ],
            if (hasAddr) ...[
              _buildInfoRow(Icons.location_on_outlined, shop.address!),
            ],
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  () => Get.toNamed(AppRoutes.shopDetail, arguments: shop),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD96C2C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 1,
              ),
              child: Text(
                'เข้าชมร้านค้า >',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: const Color(0xFFD96C2C)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.krub(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF332820),
            ),
          ),
        ),
      ],
    );
  }
}
