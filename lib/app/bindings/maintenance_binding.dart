import 'package:get/get.dart';

import '../controllers/maintenance_controller.dart';
import '../services/api_service.dart';
import '../services/maintenance_service.dart';

class MaintenanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaintenanceService>(
      () => MaintenanceService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<MaintenanceController>(
      () => MaintenanceController(
        maintenanceService: Get.find<MaintenanceService>(),
      ),
      fenix: true,
    );
  }
}
