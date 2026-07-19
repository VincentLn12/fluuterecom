import 'package:get/get.dart';

import '../models/settings_model.dart';
import '../services/settings_service.dart';

class SettingsController extends GetxController {
  final SettingsService settingsService;

  SettingsController({required this.settingsService});

  final settings = Rxn<SettingsModel>();
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      settings.value = await settingsService.getSettings();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveSettings(SettingsModel value) async {
    try {
      isSubmitting.value = true;
      settings.value = await settingsService.updateSettings(value);
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
