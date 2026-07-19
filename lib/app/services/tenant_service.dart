import '../models/tenant_model.dart';
import 'api_service.dart';

class TenantService {
  final ApiService apiService;

  TenantService({required this.apiService});

  Future<List<TenantModel>> getTenants() async {
    final response = await apiService.get('tenants') as List<dynamic>;
    return response.map((e) => TenantModel.fromJson(e)).toList();
  }

  Future<TenantModel> createTenant(TenantModel tenant) async {
    final response = await apiService.post('tenants', tenant.toJson());
    return TenantModel.fromJson(response);
  }

  Future<TenantModel> updateTenant(TenantModel tenant) async {
    final response = await apiService.put(
      'tenants/${tenant.id}',
      tenant.toJson(),
    );
    return TenantModel.fromJson(response);
  }

  Future<TenantModel> patchTenant(int id, Map<String, dynamic> body) async {
    final response = await apiService.patch('tenants/$id', body);
    return TenantModel.fromJson(response);
  }

  Future<void> deleteTenant(int id) => apiService.delete('tenants/$id');
}
