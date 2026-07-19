import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../services/api_service.dart';
import '../services/bill_service.dart';
import '../services/maintenance_service.dart';
import '../services/room_service.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoomService>(
      () => RoomService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<BillService>(
      () => BillService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<MaintenanceService>(
      () => MaintenanceService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<DashboardController>(
      () => DashboardController(
        roomService: Get.find<RoomService>(),
        billService: Get.find<BillService>(),
        maintenanceService: Get.find<MaintenanceService>(),
      ),
      fenix: true,
    );
  }
}
