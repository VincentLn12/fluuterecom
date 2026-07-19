import 'package:get/get.dart';

import '../controllers/room_controller.dart';
import '../services/api_service.dart';
import '../services/room_service.dart';

class RoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoomService>(
      () => RoomService(apiService: Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<RoomController>(
      () => RoomController(roomService: Get.find<RoomService>()),
      fenix: true,
    );
  }
}
