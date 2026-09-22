import 'package:get/get.dart';
import '../../shops/models/product_model.dart';
import '../models/admin_shop_product_model.dart';
import '../repositories/admin_repository.dart';

class AdminProductsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final shopId = ''.obs;
  final shopName = ''.obs;

  final isLoading = false.obs;
  final products = <ProductModel>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalCount = 0.obs;
  final selectedStatus = ''.obs; // '' | 'Active' | 'Inactive'

  void setShop(String id, String name) {
    shopId.value = id;
    shopName.value = name;
    loadProducts();
  }

  Future<void> loadProducts({int page = 1}) async {
    if (shopId.value.isEmpty) return;
    isLoading.value = true;
    currentPage.value = page;
    try {
      final paged = await _repository.fetchAdminProducts(
        shopId: shopId.value,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
        page: page,
        pageSize: 10,
      );

      if (paged != null) {
        products.assignAll(paged.items);
        totalPages.value = paged.totalPages;
        totalCount.value = paged.totalCount;
      } else {
        products.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleProductStatus(String productId, String currentStatus) async {
    final nextStatus = currentStatus.toLowerCase() == 'active' ? 'Inactive' : 'Active';
    final ok = await _repository.updateProductStatus(productId, nextStatus);
    if (ok) {
      Get.snackbar('สำเร็จ', 'เปลี่ยนสถานะสินค้าเป็น $nextStatus สำเร็จ', snackPosition: SnackPosition.TOP);
      loadProducts(page: currentPage.value);
    } else {
      Get.snackbar('ข้อผิดพลาด', 'อัปเดตสถานะสินค้าไม่สำเร็จ', snackPosition: SnackPosition.TOP);
    }
  }
}
