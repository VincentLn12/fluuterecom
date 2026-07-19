import '../models/settings_model.dart';
import 'api_service.dart';

class SettingsService {
  final ApiService apiService;

  SettingsService({required this.apiService});

  Future<SettingsModel> getSettings() async {
    final response = await apiService.get('settings');
    if (response is List && response.isNotEmpty) {
      return SettingsModel.fromJson(response.first);
    }
    throw 'ไม่พบข้อมูลการตั้งค่าระบบ';
  }

  Future<SettingsModel> updateSettings(SettingsModel settings) async {
    final response = await apiService.put(
      'settings/${settings.id}',
      settings.toJson(),
    );
    return SettingsModel.fromJson(response);
  }
}
