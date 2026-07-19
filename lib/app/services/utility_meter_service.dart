import '../models/utility_meter_model.dart';
import 'api_service.dart';

class UtilityMeterService {
  final ApiService apiService;

  UtilityMeterService({required this.apiService});

  Future<List<UtilityMeterModel>> getMeters() async {
    final response = await apiService.get('utilityMeters') as List<dynamic>;
    return response.map((e) => UtilityMeterModel.fromJson(e)).toList();
  }

  Future<UtilityMeterModel> createMeter(UtilityMeterModel meter) async {
    final response = await apiService.post('utilityMeters', meter.toJson());
    return UtilityMeterModel.fromJson(response);
  }

  Future<UtilityMeterModel> updateMeter(UtilityMeterModel meter) async {
    final response = await apiService.put(
      'utilityMeters/${meter.id}',
      meter.toJson(),
    );
    return UtilityMeterModel.fromJson(response);
  }

  Future<void> deleteMeter(int id) => apiService.delete('utilityMeters/$id');
}
