import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../shops/models/shop_model.dart';
import '../../controllers/admin_products_controller.dart';
import 'widgets/manage_products_list.dart';
import 'widgets/manage_products_status_filter.dart';

class AdminManageProductsPage extends StatefulWidget {
  const AdminManageProductsPage({super.key});

  @override
  State<AdminManageProductsPage> createState() =>
      _AdminManageProductsPageState();
}

class _AdminManageProductsPageState extends State<AdminManageProductsPage> {
  late final AdminProductsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AdminProductsController>();
    final shop = Get.arguments;
    if (shop is ShopModel) {
      controller.setShop(shop.shopId, shop.shopName);
    } else {
      controller.setShop('', '');
    }
  }

  @override
  Widget build(BuildContext context) {
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
