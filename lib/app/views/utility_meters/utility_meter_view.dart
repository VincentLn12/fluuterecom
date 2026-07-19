import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/room_controller.dart';
import '../../controllers/utility_meter_controller.dart';
import '../../models/utility_meter_model.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/validators.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/month_picker_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/room_dropdown.dart';

class UtilityMeterView extends GetView<UtilityMeterController> {
  UtilityMeterView({super.key});

  final roomController = Get.find<RoomController>();
  final filterMonthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('มิเตอร์น้ำและไฟ')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMeterForm(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingWidget();
        if (controller.errorMessage.value.isNotEmpty &&
            controller.meters.isEmpty) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchData,
          );
        }
        final items = controller.filteredMeters;
        return RefreshIndicator(
          onRefresh: controller.fetchData,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'ค้นหา Room ID',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => controller.searchText.value = value,
              ),
              const SizedBox(height: 12),
              MonthPickerField(
                controller: filterMonthController,
                label: 'กรองตามเดือน',
                validator: (_) => null,
                helpText: 'เลือกเดือนสำหรับกรองมิเตอร์',
                onChanged: (value) => controller.selectedMonth.value = value,
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                const SizedBox(
                  height: 280,
                  child: EmptyState(title: 'ยังไม่มีข้อมูลมิเตอร์'),
                ),
              ...items.map(
                (meter) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text('ห้อง ${meter.roomId} • ${meter.month}'),
                    subtitle: Text(
                      'น้ำ ${meter.waterUnits} หน่วย • ไฟ ${meter.electricUnits} หน่วย',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showMeterForm(context, meter: meter);
                        } else {
                          Get.dialog(
                            ConfirmDeleteDialog(
                              title: 'ลบข้อมูลมิเตอร์',
                              content:
                                  'ต้องการลบข้อมูลเดือน ${meter.month} ใช่หรือไม่',
                              onConfirm: () async =>
                                  controller.deleteMeter(meter.id!),
                            ),
                          );
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('แก้ไข')),
                        PopupMenuItem(value: 'delete', child: Text('ลบ')),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _showMeterForm(
    BuildContext context, {
    UtilityMeterModel? meter,
  }) async {
    final formKey = GlobalKey<FormState>();
    final monthController = TextEditingController(text: meter?.month ?? '');
    final previousWaterController = TextEditingController(
      text: meter?.previousWater.toString() ?? '',
    );
    final currentWaterController = TextEditingController(
      text: meter?.currentWater.toString() ?? '',
    );
    final previousElectricController = TextEditingController(
      text: meter?.previousElectric.toString() ?? '',
    );
    final currentElectricController = TextEditingController(
      text: meter?.currentElectric.toString() ?? '',
    );
    int? roomId = meter?.roomId;
    final settings = controller.settings.value;

    await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoomDropdown(
                  value: roomId,
                  rooms: roomController.rooms,
                  onChanged: (value) => roomId = value,
                ),
                const SizedBox(height: 12),
                MonthPickerField(controller: monthController, label: 'เดือน'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: previousWaterController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'มิเตอร์น้ำครั้งก่อน',
                  ),
                  validator: (value) => Validators.nonNegative(
                    value,
                    label: 'มิเตอร์น้ำครั้งก่อน',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: currentWaterController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'มิเตอร์น้ำปัจจุบัน',
                  ),
                  validator: (value) => Validators.nonNegative(
                    value,
                    label: 'มิเตอร์น้ำปัจจุบัน',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: previousElectricController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'มิเตอร์ไฟครั้งก่อน',
                  ),
                  validator: (value) => Validators.nonNegative(
                    value,
                    label: 'มิเตอร์ไฟครั้งก่อน',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: currentElectricController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'มิเตอร์ไฟปัจจุบัน',
                  ),
                  validator: (value) =>
                      Validators.nonNegative(value, label: 'มิเตอร์ไฟปัจจุบัน'),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => PrimaryButton(
                    isLoading: controller.isSubmitting.value,
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final previousWater = double.parse(
                        previousWaterController.text.trim(),
                      );
                      final currentWater = double.parse(
                        currentWaterController.text.trim(),
                      );
                      final previousElectric = double.parse(
                        previousElectricController.text.trim(),
                      );
                      final currentElectric = double.parse(
                        currentElectricController.text.trim(),
                      );
                      final waterError = Validators.meter(
                        previous: previousWater,
                        current: currentWater,
                        label: 'มิเตอร์น้ำ',
                      );
                      final electricError = Validators.meter(
                        previous: previousElectric,
                        current: currentElectric,
                        label: 'มิเตอร์ไฟ',
                      );
                      if (waterError != null || electricError != null) {
                        Get.snackbar(
                          'เกิดข้อผิดพลาด',
                          waterError ?? electricError!,
                        );
                        return;
                      }
                      final success = await controller.saveMeter(
                        UtilityMeterModel(
                          id: meter?.id,
                          roomId: roomId!,
                          month: monthController.text.trim(),
                          previousWater: previousWater,
                          currentWater: currentWater,
                          previousElectric: previousElectric,
                          currentElectric: currentElectric,
                          waterRate: settings?.waterRate ?? 18,
                          electricRate: settings?.electricRate ?? 8,
                          waterUnits: 0,
                          electricUnits: 0,
                          waterAmount: 0,
                          electricAmount: 0,
                        ),
                      );
                      if (success) {
                        Get.back();
                        Get.snackbar(
                          'สำเร็จ',
                          'บันทึกข้อมูลมิเตอร์เรียบร้อยแล้ว',
                        );
                      } else {
                        Get.snackbar(
                          'เกิดข้อผิดพลาด',
                          controller.errorMessage.value,
                        );
                      }
                    },
                    label: 'บันทึกข้อมูล',
                  ),
                ),
                if (meter != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'ค่าน้ำ ${CurrencyFormatter.format(meter.waterAmount)} • ค่าไฟ ${CurrencyFormatter.format(meter.electricAmount)}',
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
