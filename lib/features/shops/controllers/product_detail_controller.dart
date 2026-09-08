import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/shop_model.dart';
import '../repositories/shop_repository.dart';

class ProductDetailController extends GetxController {
  ProductDetailController({ShopRepository? repository})
      : _repository = repository ?? ShopRepository();

  final ShopRepository _repository;

  final product = Rxn<ProductModel>();
  final sellerShop = Rxn<ShopModel>();
  final quantity = 1.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      product.value = args;
      loadProductAndShop(args.id, args.shopId);
    } else if (args is String) {
      loadProductAndShop(args, null);
    }
  }

  Future<void> loadProductAndShop(String productId, String? shopId) async {
    isLoading.value = true;
    try {
      final item = await _repository.fetchProductById(productId);
      if (item != null) {
        product.value = item;
      }
      final targetShopId = shopId ?? product.value?.shopId;
      if (targetShopId != null && targetShopId.isNotEmpty) {
        final s = await _repository.fetchShopById(targetShopId);
        sellerShop.value = s;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
}
