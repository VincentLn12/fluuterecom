import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';
import '../../controllers/admin_payouts_controller.dart';
import 'widgets/admin_pending_payout_card.dart';
import 'widgets/admin_payout_history_card.dart';
import 'widgets/admin_payouts_tab_bar.dart';
import 'widgets/admin_payouts_empty_state.dart';

class AdminPayoutsPage extends GetView<AdminPayoutsController> {
  const AdminPayoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminPayoutsController>()) {
      Get.put(AdminPayoutsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'โอนเงินให้ร้านค้า (Merchant Payouts)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AdminPayoutsTabBar(controller: controller),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.activeTab.value == 0) {
          final pending = controller.pendingPayouts;
          if (pending.isEmpty) {
            return const AdminPayoutsEmptyState(
              message: 'ไม่มีรายการสั่งจ่ายรอโอนในขณะนี้',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pending.length,
            itemBuilder: (context, index) => AdminPendingPayoutCard(
              controller: controller,
              payout: pending[index],
            ),
          );
        } else {
          final history = controller.payoutHistory;
          if (history.isEmpty) {
            return const AdminPayoutsEmptyState(
              message: 'ยังไม่มีประวัติการโอนเงิน',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) =>
                AdminPayoutHistoryCard(record: history[index]),
          );
        }
      }),
    );
  }
}
