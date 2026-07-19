import 'package:get/get.dart';

import '../controllers/utility_meter_controller.dart';
import '../services/api_service.dart';
import '../services/settings_service.dart';
import '../services/utility_meter_service.dart';

class UtilityMeterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UtilityMeterService>(
      () => UtilityMeterService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<UtilityMeterController>(
      () => UtilityMeterController(
        meterService: Get.find<UtilityMeterService>(),
        settingsService: Get.find<SettingsService>(),
      ),
      fenix: true,
    );
  }
}
