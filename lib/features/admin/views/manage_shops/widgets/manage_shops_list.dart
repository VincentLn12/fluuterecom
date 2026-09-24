import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../controllers/admin_shops_controller.dart';
import 'admin_shop_card.dart';

class ManageShopsList extends StatelessWidget {
  const ManageShopsList({super.key, required this.controller});

  final AdminShopsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }
      if (controller.shops.isEmpty) {
        return Center(
          child: Text(
            'ไม่พบรายการร้านค้า',
            style: GoogleFonts.krub(color: AppColors.textSecondary),
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.shops.length,
        itemBuilder: (context, index) => AdminShopCard(
          shop: controller.shops[index],
          controller: controller,
        ),
      );
    });
  }
}
