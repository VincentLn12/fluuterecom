import 'package:get/get.dart';

import '../models/room_model.dart';
import '../services/room_service.dart';

class RoomController extends GetxController {
  final RoomService roomService;

  RoomController({required this.roomService});

  final rooms = <RoomModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;
  final searchText = ''.obs;
  final selectedStatus = 'all'.obs;
  final selectedFloor = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      rooms.value = await roomService.getRooms();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<RoomModel> get filteredRooms {
    return rooms.where((room) {
      final matchSearch = room.roomNumber.contains(searchText.value.trim());
      final matchStatus =
          selectedStatus.value == 'all' || room.status == selectedStatus.value;
      final matchFloor =
          selectedFloor.value == 0 || room.floor == selectedFloor.value;
      return matchSearch && matchStatus && matchFloor;
    }).toList()..sort((a, b) => a.roomNumber.compareTo(b.roomNumber));
  }

  int countByStatus(String status) =>
      rooms.where((room) => room.status == status).length;

  Future<bool> saveRoom(RoomModel room) async {
    try {
      isSubmitting.value = true;
      if (room.id == null) {
        await roomService.createRoom(room);
      } else {
        await roomService.updateRoom(room);
      }
      await fetchRooms();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteRoom(int id) async {
    try {
      isSubmitting.value = true;
      await roomService.deleteRoom(id);
      await fetchRooms();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
