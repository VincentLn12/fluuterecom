import 'dart:io';
import 'package:get/get.dart';
import '../models/admin_merchant_payout_model.dart';
import '../repositories/admin_repository.dart';

class AdminPayoutsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final activeTab = 0.obs; // 0: Pending, 1: History
  final pendingPayouts = <AdminMerchantPayoutGroup>[].obs;
  final payoutHistory = <MerchantPayoutRecord>[].obs;

  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      if (activeTab.value == 0) {
        final list = await _repository.fetchPayouts();
        pendingPayouts.assignAll(list);
      } else {
        final list = await _repository.fetchPayoutHistory();
        payoutHistory.assignAll(list);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void switchTab(int index) {
    activeTab.value = index;
    loadData();
  }

  Future<bool> confirmPayout({
    required String shopId,
    required List<String> orderIds,
    String? transactionRef,
    String? note,
    File? slipFile,
  }) async {
    isSubmitting.value = true;
    try {
      final ok = await _repository.confirmPayout(
        shopId: shopId,
        orderIds: orderIds,
        transactionRef: transactionRef,
        note: note,
        slipFile: slipFile,
      );
      if (ok) {
        Get.snackbar('สำเร็จ', 'ยืนยันการโอนเงินให้ร้านค้าเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
        loadData();
      } else {
        Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถบันทึกการโอนเงินได้', snackPosition: SnackPosition.TOP);
      }
      return ok;
    } finally {
      isSubmitting.value = false;
    }
  }
}
