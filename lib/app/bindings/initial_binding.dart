import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/settings_controller.dart';
import '../services/api_service.dart';
import '../services/settings_service.dart';
import '../services/user_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.put(NavigationController(), permanent: true);
    Get.lazyPut<UserService>(
      () => UserService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.put(
      AuthController(userService: Get.find<UserService>()),
      permanent: true,
    );
    Get.lazyPut<SettingsService>(
      () => SettingsService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.put(
      SettingsController(settingsService: Get.find<SettingsService>()),
      permanent: true,
    );
  }
}
