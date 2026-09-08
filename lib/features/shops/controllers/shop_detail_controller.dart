import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/shop_model.dart';
import '../repositories/shop_repository.dart';

class ShopDetailController extends GetxController {
  ShopDetailController({ShopRepository? repository})
      : _repository = repository ?? ShopRepository();

  final ShopRepository _repository;

  final shop = Rxn<ShopModel>();
  final products = <ProductModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ShopModel) {
      shop.value = args;
      loadShopDetailAndProducts(args.id);
    } else if (args is String) {
      loadShopDetailAndProducts(args);
    }
  }

  Future<void> loadShopDetailAndProducts(String shopId) async {
    isLoading.value = true;
    try {
      final detail = await _repository.fetchShopById(shopId);
      if (detail != null) {
        shop.value = detail;
      }
      final shopProducts = await _repository.fetchProducts(shopId: shopId);
      products.assignAll(shopProducts);
    } finally {
      isLoading.value = false;
    }
  }
}
