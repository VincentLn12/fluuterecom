import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../features/cart/controllers/cart_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient(), permanent: true);
    Get.put(CartController(), permanent: true);
  }
}
