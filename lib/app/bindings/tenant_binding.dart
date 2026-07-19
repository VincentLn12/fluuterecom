import 'package:get/get.dart';

import '../controllers/tenant_controller.dart';
import '../services/api_service.dart';
import '../services/room_service.dart';
import '../services/tenant_service.dart';

class TenantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoomService>(
      () => RoomService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<TenantService>(
      () => TenantService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<TenantController>(
      () => TenantController(
        tenantService: Get.find<TenantService>(),
        roomService: Get.find<RoomService>(),
      ),
      fenix: true,
    );
  }
}
