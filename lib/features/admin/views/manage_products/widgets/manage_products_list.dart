import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_products_controller.dart';
import 'admin_shop_product_card.dart';

class ManageProductsList extends StatelessWidget {
  const ManageProductsList({super.key, required this.controller});

  final AdminProductsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      final products = controller.products;
      if (products.isEmpty) {
        return Center(
          child: Text(
            'ไม่พบรายการสินค้าในร้านค้านี้',
            style: GoogleFonts.krub(color: AppColors.textSecondary),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) => AdminShopProductCard(
          product: products[index],
          controller: controller,
        ),
      );
    });
  }
}
