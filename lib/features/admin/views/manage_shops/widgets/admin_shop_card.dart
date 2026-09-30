import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_shops_controller.dart';
import '../../../../shops/models/shop_model.dart';
import 'admin_shop_status_badge.dart';

class AdminShopCard extends StatelessWidget {
  const AdminShopCard({
    super.key,
    required this.shop,
    required this.controller,
  });

  final ShopModel shop;
  final AdminShopsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: shop.coverImageUrl != null
                    ? NetworkImage(shop.coverImageUrl!)
                    : null,
                child: shop.coverImageUrl == null
                    ? const Icon(Icons.store, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.shopName,
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'โทร: ${shop.phone ?? '-'} | อีเมล: ${shop.email ?? '-'}',
                      style: GoogleFonts.krub(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              AdminShopStatusBadge(status: shop.status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'หมวดหมู่: ${shop.categoryName ?? '-'} | ที่อยู่: ${shop.address ?? '-'}',
            style: GoogleFonts.krub(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.inventory_2_outlined, size: 16),
                label: Text(
                  'ดูสินค้าในร้าน',
                  style: GoogleFonts.krub(fontSize: 12),
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.adminShopProducts, arguments: shop);
                },
              ),
              PopupMenuButton<String>(
                onSelected: (status) =>
                    controller.changeShopStatus(shop.shopId, status),
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'Active',
                    child: Text('อนุมัติ/เปิดใช้งาน (Active)'),
                  ),
                  PopupMenuItem(
                    value: 'Suspended',
                    child: Text('ระงับการใช้งาน (Suspended)'),
                  ),
                  PopupMenuItem(
                    value: 'Closed',
                    child: Text('ปิดบริการ (Closed)'),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'เปลี่ยนสถานะ',
                        style: GoogleFonts.krub(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
