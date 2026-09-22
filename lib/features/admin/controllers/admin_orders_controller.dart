import 'package:get/get.dart';
import '../models/admin_order_slip_model.dart';
import '../repositories/admin_repository.dart';

class AdminOrdersController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final pendingSlips = <AdminPendingSlipGroup>[].obs;
  final isProcessingAction = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPendingSlips();
  }

  Future<void> loadPendingSlips() async {
    isLoading.value = true;
    try {
      final list = await _repository.fetchPendingSlips();
      pendingSlips.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifySlip(List<String> orderIds, String action) async {
    if (orderIds.isEmpty) return;
    isProcessingAction.value = true;
    try {
      final payload = VerifySlipPayload(orderIds: orderIds, action: action);
      final success = await _repository.verifySlip(payload);
      if (success) {
        Get.snackbar(
          'สำเร็จ',
          action == 'Approve' ? 'อนุมัติการชำระเงินเรียบร้อยแล้ว' : 'ปฏิเสธการชำระเงินเรียบร้อยแล้ว',
          snackPosition: SnackPosition.TOP,
        );
        loadPendingSlips();
      } else {
        Get.snackbar('ข้อผิดพลาด', 'ทำรายการไม่สำเร็จ กรุณาลองใหม่', snackPosition: SnackPosition.TOP);
      }
    } finally {
      isProcessingAction.value = false;
    }
  }
}
