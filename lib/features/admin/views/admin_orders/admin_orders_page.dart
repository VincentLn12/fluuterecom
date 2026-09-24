import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';
import '../../controllers/admin_orders_controller.dart';
import 'widgets/admin_slip_group_card.dart';
import 'widgets/admin_orders_empty_state.dart';

class AdminOrdersPage extends GetView<AdminOrdersController> {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminOrdersController>()) {
      Get.put(AdminOrdersController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'ตรวจสอบสลิปการชำระเงิน',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.loadPendingSlips(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final groups = controller.pendingSlips;

        if (groups.isEmpty) {
          return const AdminOrdersEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return AdminSlipGroupCard(controller: controller, group: group);
          },
        );
      }),
    );
  }
}
