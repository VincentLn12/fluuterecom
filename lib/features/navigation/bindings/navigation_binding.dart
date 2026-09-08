import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../shops/controllers/shop_controller.dart';
import '../../contents/controllers/content_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ShopController>(() => ShopController());
    Get.lazyPut<ContentController>(() => ContentController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
