import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/settings_controller.dart';
import '../../models/settings_model.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';

class SettingsView extends StatefulWidget {
  final bool isReadOnlyTenantMode;

  const SettingsView({super.key, this.isReadOnlyTenantMode = false});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final controller = Get.find<SettingsController>();
  final formKey = GlobalKey<FormState>();
  final dormitoryNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final waterRateController = TextEditingController();
  final electricRateController = TextEditingController();
  final defaultDueDayController = TextEditingController();

  @override
  void dispose() {
    dormitoryNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    waterRateController.dispose();
    electricRateController.dispose();
    defaultDueDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ตั้งค่าระบบ')),
      body: Obx(() {
        if (controller.isLoading.value && controller.settings.value == null) {
          return const LoadingWidget();
        }
        if (controller.errorMessage.value.isNotEmpty &&
            controller.settings.value == null) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchSettings,
          );
        }
        final settings = controller.settings.value!;
        dormitoryNameController.text = settings.dormitoryName;
        addressController.text = settings.address;
        phoneController.text = settings.phone;
        waterRateController.text = settings.waterRate.toString();
        electricRateController.text = settings.electricRate.toString();
        defaultDueDayController.text = settings.defaultDueDay.toString();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: dormitoryNameController,
                    label: 'ชื่อหอพัก',
                    validator: (value) =>
                        Validators.requiredField(value, label: 'ชื่อหอพัก'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: addressController,
                    label: 'ที่อยู่',
                    maxLines: 3,
                    validator: (value) =>
                        Validators.requiredField(value, label: 'ที่อยู่'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: phoneController,
                    label: 'เบอร์โทรศัพท์',
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: waterRateController,
                    label: 'ค่าน้ำต่อหน่วย',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.nonNegative(value, label: 'ค่าน้ำ'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: electricRateController,
                    label: 'ค่าไฟต่อหน่วย',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.nonNegative(value, label: 'ค่าไฟ'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: defaultDueDayController,
                    label: 'วันครบกำหนดเริ่มต้น',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        Validators.requiredField(value, label: 'วันครบกำหนด'),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    isLoading: controller.isSubmitting.value,
                    onPressed: widget.isReadOnlyTenantMode
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;
                            final success = await controller.saveSettings(
                              SettingsModel(
                                id: settings.id,
                                dormitoryName: dormitoryNameController.text
                                    .trim(),
                                address: addressController.text.trim(),
                                phone: phoneController.text.trim(),
                                waterRate: double.parse(
                                  waterRateController.text.trim(),
                                ),
                                electricRate: double.parse(
                                  electricRateController.text.trim(),
                                ),
                                defaultDueDay: int.parse(
                                  defaultDueDayController.text.trim(),
                                ),
                              ),
                            );
                            if (success) {
                              Get.snackbar(
                                'สำเร็จ',
                                'บันทึกการตั้งค่าเรียบร้อยแล้ว',
                              );
                            } else {
                              Get.snackbar(
                                'เกิดข้อผิดพลาด',
                                controller.errorMessage.value,
                              );
                            }
                          },
                    label: widget.isReadOnlyTenantMode
                        ? 'ข้อมูลระบบ'
                        : 'บันทึกการตั้งค่า',
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
