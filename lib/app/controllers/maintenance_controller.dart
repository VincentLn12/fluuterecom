import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/maintenance_request_model.dart';
import '../services/maintenance_service.dart';

class MaintenanceController extends GetxController {
  final MaintenanceService maintenanceService;

  MaintenanceController({required this.maintenanceService});

  final requests = <MaintenanceRequestModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;
  final searchText = ''.obs;
  final selectedPriority = 'all'.obs;
  final selectedStatus = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      requests.value = await maintenanceService.getRequests();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<MaintenanceRequestModel> get filteredRequests => requests.where((item) {
    final keyword = searchText.value.trim().toLowerCase();
    final matchSearch =
        keyword.isEmpty ||
        item.title.toLowerCase().contains(keyword) ||
        item.roomId.toString().contains(keyword);
    final matchPriority =
        selectedPriority.value == 'all' ||
        item.priority == selectedPriority.value;
    final matchStatus =
        selectedStatus.value == 'all' || item.status == selectedStatus.value;
    return matchSearch && matchPriority && matchStatus;
  }).toList();

  Future<bool> saveRequest(MaintenanceRequestModel request) async {
    try {
      isSubmitting.value = true;
      if (request.id == null) {
        await maintenanceService.createRequest(request);
      } else {
        await maintenanceService.updateRequest(request);
      }
      await fetchRequests();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateMaintenanceStatus(
    MaintenanceRequestModel request,
    String status,
  ) async {
    try {
      isSubmitting.value = true;
      await maintenanceService.patchRequest(request.id!, {
        'status': status,
        'completedAt': status == 'completed'
            ? DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now())
            : null,
      });
      await fetchRequests();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteRequest(int id) async {
    try {
      isSubmitting.value = true;
      await maintenanceService.deleteRequest(id);
      await fetchRequests();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
