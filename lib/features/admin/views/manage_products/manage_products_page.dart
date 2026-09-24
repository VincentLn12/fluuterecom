import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../controllers/admin_products_controller.dart';
import 'widgets/manage_products_list.dart';
import 'widgets/manage_products_status_filter.dart';

class ManageProductsPage extends GetView<AdminProductsController> {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminProductsController>()) {
      Get.put(AdminProductsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Obx(
          () => Text(
            controller.shopName.value.isNotEmpty
                ? 'สินค้าในร้าน: ${controller.shopName.value}'
                : 'จัดการสินค้าในร้านค้า',
            style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
      body: Column(
        children: [
          ManageProductsStatusFilter(controller: controller),
          Expanded(child: ManageProductsList(controller: controller)),
        ],
      ),
    );
  }
}
