import 'package:get/get.dart';

import '../models/settings_model.dart';
import '../models/utility_meter_model.dart';
import '../services/settings_service.dart';
import '../services/utility_meter_service.dart';

class UtilityMeterController extends GetxController {
  final UtilityMeterService meterService;
  final SettingsService settingsService;

  UtilityMeterController({
    required this.meterService,
    required this.settingsService,
  });

  final meters = <UtilityMeterModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;
  final searchText = ''.obs;
  final selectedMonth = ''.obs;
  final settings = Rxn<SettingsModel>();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      meters.value = await meterService.getMeters();
      settings.value = await settingsService.getSettings();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<UtilityMeterModel> get filteredMeters => meters.where((meter) {
    final roomMatch =
        searchText.value.isEmpty ||
        meter.roomId.toString().contains(searchText.value.trim());
    final monthMatch =
        selectedMonth.value.isEmpty || meter.month == selectedMonth.value;
    return roomMatch && monthMatch;
  }).toList();

  UtilityMeterModel calculate(UtilityMeterModel meter) {
    final waterUnits = meter.currentWater - meter.previousWater;
    final electricUnits = meter.currentElectric - meter.previousElectric;
    return meter.copyWith(
      waterUnits: waterUnits,
      electricUnits: electricUnits,
      waterAmount: waterUnits * meter.waterRate,
      electricAmount: electricUnits * meter.electricRate,
    );
  }

  Future<bool> saveMeter(UtilityMeterModel meter) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      final duplicate = meters.any(
        (item) =>
            item.roomId == meter.roomId &&
            item.month == meter.month &&
            item.id != meter.id,
      );
      if (duplicate) throw 'ห้องนี้มีข้อมูลมิเตอร์ของเดือนนี้แล้ว';

      final computed = calculate(meter);
      if (computed.waterUnits < 0 || computed.electricUnits < 0) {
        throw 'จำนวนหน่วยมิเตอร์ต้องไม่ติดลบ';
      }

      if (meter.id == null) {
        await meterService.createMeter(computed);
      } else {
        await meterService.updateMeter(computed);
      }
      await fetchData();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteMeter(int id) async {
    try {
      isSubmitting.value = true;
      await meterService.deleteMeter(id);
      await fetchData();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
