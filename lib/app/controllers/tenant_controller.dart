import 'package:get/get.dart';

import '../models/room_model.dart';
import '../models/tenant_model.dart';
import '../services/room_service.dart';
import '../services/tenant_service.dart';

class TenantController extends GetxController {
  final TenantService tenantService;
  final RoomService roomService;

  TenantController({required this.tenantService, required this.roomService});

  final tenants = <TenantModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;
  final searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTenants();
  }

  Future<void> fetchTenants() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      tenants.value = await tenantService.getTenants();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<TenantModel> get filteredTenants {
    final keyword = searchText.value.trim().toLowerCase();
    return tenants.where((tenant) {
      return tenant.fullName.toLowerCase().contains(keyword) ||
          tenant.phone.contains(keyword);
    }).toList();
  }

  Future<List<RoomModel>> getVacantRooms({int? includeRoomId}) async {
    final rooms = await roomService.getRooms();
    return rooms.where((room) {
      return room.status == 'vacant' || room.id == includeRoomId;
    }).toList();
  }

  Future<bool> saveTenant(TenantModel tenant, {int? previousRoomId}) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      final activeInRoom = tenants.where((item) {
        final sameRoom = item.roomId == tenant.roomId;
        final samePerson = item.id == tenant.id;
        return sameRoom && item.isActive && !samePerson;
      }).isNotEmpty;

      if (tenant.isActive && activeInRoom) {
        throw 'ห้องนี้มีผู้เช่าอยู่แล้ว';
      }

      if (tenant.id == null) {
        await tenantService.createTenant(tenant);
      } else {
        await tenantService.updateTenant(tenant);
      }

      await roomService.patchRoom(tenant.roomId, {
        'status': tenant.isActive ? 'occupied' : 'vacant',
      });

      if (previousRoomId != null && previousRoomId != tenant.roomId) {
        await roomService.patchRoom(previousRoomId, {'status': 'vacant'});
      }

      await fetchTenants();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> markTenantMovedOut(
    TenantModel tenant,
    String moveOutDate,
  ) async {
    try {
      isSubmitting.value = true;
      await tenantService.patchTenant(tenant.id!, {
        'status': 'inactive',
        'moveOutDate': moveOutDate,
      });
      await roomService.patchRoom(tenant.roomId, {'status': 'vacant'});
      await fetchTenants();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteTenant(TenantModel tenant) async {
    try {
      isSubmitting.value = true;
      await tenantService.deleteTenant(tenant.id!);
      if (tenant.isActive) {
        await roomService.patchRoom(tenant.roomId, {'status': 'vacant'});
      }
      await fetchTenants();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
