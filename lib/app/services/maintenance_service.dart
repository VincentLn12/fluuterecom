import '../models/maintenance_request_model.dart';
import 'api_service.dart';

class MaintenanceService {
  final ApiService apiService;

  MaintenanceService({required this.apiService});

  Future<List<MaintenanceRequestModel>> getRequests() async {
    final response =
        await apiService.get('maintenanceRequests') as List<dynamic>;
    return response.map((e) => MaintenanceRequestModel.fromJson(e)).toList();
  }

  Future<MaintenanceRequestModel> createRequest(
    MaintenanceRequestModel request,
  ) async {
    final response = await apiService.post(
      'maintenanceRequests',
      request.toJson(),
    );
    return MaintenanceRequestModel.fromJson(response);
  }

  Future<MaintenanceRequestModel> updateRequest(
    MaintenanceRequestModel request,
  ) async {
    final response = await apiService.put(
      'maintenanceRequests/${request.id}',
      request.toJson(),
    );
    return MaintenanceRequestModel.fromJson(response);
  }

  Future<MaintenanceRequestModel> patchRequest(
    int id,
    Map<String, dynamic> body,
  ) async {
    final response = await apiService.patch('maintenanceRequests/$id', body);
    return MaintenanceRequestModel.fromJson(response);
  }

  Future<void> deleteRequest(int id) =>
      apiService.delete('maintenanceRequests/$id');
}
