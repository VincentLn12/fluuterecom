import 'package:get/get.dart';
import '../../shops/models/product_model.dart';
import '../repositories/admin_repository.dart';

class AdminProductsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();
  int _loadToken = 0;

  final shopId = ''.obs;
  final shopName = ''.obs;

  final isLoading = false.obs;
  final products = <ProductModel>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalCount = 0.obs;
  final selectedStatus = ''.obs; // '' | 'Active' | 'Inactive'

  void setShop(String id, String name) {
    _loadToken++;
    shopId.value = id;
    shopName.value = name;
    selectedStatus.value = '';
    currentPage.value = 1;
    totalPages.value = 1;
    totalCount.value = 0;
    products.clear();
    isLoading.value = false;
    loadProducts();
  }

  Future<void> loadProducts({int page = 1}) async {
    if (shopId.value.isEmpty) return;
    final requestedShopId = shopId.value;
    final requestedStatus = selectedStatus.value;
    final loadToken = ++_loadToken;
    isLoading.value = true;
    currentPage.value = page;
    try {
      final paged = await _repository.fetchAdminProducts(
        shopId: requestedShopId,
        status: requestedStatus.isEmpty ? null : requestedStatus,
        page: page,
        pageSize: 10,
      );

      if (loadToken != _loadToken) return;

      if (paged != null) {
        products.assignAll(paged.items);
        totalPages.value = paged.totalPages;
        totalCount.value = paged.totalCount;
      } else {
        products.clear();
        totalPages.value = 1;
        totalCount.value = 0;
      }
    } finally {
      if (loadToken == _loadToken) isLoading.value = false;
    }
  }

  Future<void> toggleProductStatus(
    String productId,
    String currentStatus,
  ) async {
    final nextStatus = currentStatus.toLowerCase() == 'active'
        ? 'Inactive'
        : 'Active';
    final ok = await _repository.updateProductStatus(productId, nextStatus);
    if (ok) {
      Get.snackbar(
        'สำเร็จ',
        'เปลี่ยนสถานะสินค้าเป็น $nextStatus สำเร็จ',
        snackPosition: SnackPosition.TOP,
      );
      loadProducts(page: currentPage.value);
    } else {
      Get.snackbar(
        'ข้อผิดพลาด',
        'อัปเดตสถานะสินค้าไม่สำเร็จ',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
