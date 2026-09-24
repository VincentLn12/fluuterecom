import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../controllers/admin_shops_controller.dart';
import 'widgets/manage_shops_filter_panel.dart';
import 'widgets/manage_shops_list.dart';

class ManageShopsPage extends GetView<AdminShopsController> {
  const ManageShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminShopsController>()) {
      Get.put(AdminShopsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'อนุมัติและจัดการร้านค้า (Shop Management)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          ManageShopsFilterPanel(controller: controller),
          Expanded(child: ManageShopsList(controller: controller)),
        ],
      ),
    );
  }
}
