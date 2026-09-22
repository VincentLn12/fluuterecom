import 'package:get/get.dart';
import '../../shops/models/shop_model.dart';
import '../models/admin_shop_product_model.dart';
import '../repositories/admin_repository.dart';

class AdminShopsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final shops = <ShopModel>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalCount = 0.obs;

  final searchQuery = ''.obs;
  final selectedStatus = ''.obs; // '' | 'Pending' | 'Active' | 'Suspended' | 'Closed'

  @override
  void onInit() {
    super.onInit();
    loadShops();
  }

  Future<void> loadShops({int page = 1}) async {
    isLoading.value = true;
    currentPage.value = page;
    try {
      final paged = await _repository.fetchAdminShops(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
        page: page,
        pageSize: 10,
      );

      if (paged != null) {
        shops.assignAll(paged.items);
        totalPages.value = paged.totalPages;
        totalCount.value = paged.totalCount;
      } else {
        shops.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeShopStatus(String shopId, String newStatus) async {
    final ok = await _repository.updateShopStatus(shopId, newStatus);
    if (ok) {
      Get.snackbar('สำเร็จ', 'อัปเดตสถานะร้านค้าเป็น $newStatus สำเร็จ', snackPosition: SnackPosition.TOP);
      loadShops(page: currentPage.value);
    } else {
      Get.snackbar('ข้อผิดพลาด', 'อัปเดตสถานะร้านค้าไม่สำเร็จ', snackPosition: SnackPosition.TOP);
    }
  }
}
