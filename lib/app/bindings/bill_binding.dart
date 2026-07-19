import 'package:get/get.dart';

import '../controllers/bill_controller.dart';
import '../services/api_service.dart';
import '../services/bill_service.dart';
import '../services/room_service.dart';
import '../services/settings_service.dart';
import '../services/tenant_service.dart';
import '../services/utility_meter_service.dart';

class BillBinding extends Bindings {
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
    Get.lazyPut<UtilityMeterService>(
      () => UtilityMeterService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<BillService>(
      () => BillService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<SettingsService>(
      () => SettingsService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<BillController>(
      () => BillController(
        billService: Get.find<BillService>(),
        roomService: Get.find<RoomService>(),
        tenantService: Get.find<TenantService>(),
        meterService: Get.find<UtilityMeterService>(),
        settingsService: Get.find<SettingsService>(),
      ),
      fenix: true,
    );
  }
}
