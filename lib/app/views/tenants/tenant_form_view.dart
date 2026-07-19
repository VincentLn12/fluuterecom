import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/tenant_controller.dart';
import '../../models/tenant_model.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/room_dropdown.dart';

class TenantFormView extends StatefulWidget {
  const TenantFormView({super.key});

  @override
  State<TenantFormView> createState() => _TenantFormViewState();
}

class _TenantFormViewState extends State<TenantFormView> {
  final controller = Get.find<TenantController>();
  final formKey = GlobalKey<FormState>();
  final tenant = Get.arguments as TenantModel?;

  final prefixController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final idCardController = TextEditingController();
  final addressController = TextEditingController();
  final moveInDateController = TextEditingController();
  int? selectedRoomId;
  String status = 'active';
  List rooms = [];

  @override
  void initState() {
    super.initState();
    prefixController.text = tenant?.prefix ?? 'นาย';
    firstNameController.text = tenant?.firstName ?? '';
    lastNameController.text = tenant?.lastName ?? '';
    phoneController.text = tenant?.phone ?? '';
    emailController.text = tenant?.email ?? '';
    idCardController.text = tenant?.idCard ?? '';
    addressController.text = tenant?.address ?? '';
    moveInDateController.text =
        tenant?.moveInDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    selectedRoomId = tenant?.roomId;
    status = tenant?.status ?? 'active';
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    rooms = await controller.getVacantRooms(includeRoomId: tenant?.roomId);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    prefixController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    idCardController.dispose();
    addressController.dispose();
    moveInDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tenant == null ? 'เพิ่มผู้เช่า' : 'แก้ไขผู้เช่า'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: prefixController,
                  label: 'คำนำหน้า',
                  validator: (value) =>
                      Validators.requiredField(value, label: 'คำนำหน้า'),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: firstNameController,
                  label: 'ชื่อ',
                  validator: (value) =>
                      Validators.requiredField(value, label: 'ชื่อ'),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: lastNameController,
                  label: 'นามสกุล',
                  validator: (value) =>
                      Validators.requiredField(value, label: 'นามสกุล'),
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
                  controller: emailController,
                  label: 'อีเมล',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: idCardController,
                  label: 'เลขบัตรประชาชน',
                  keyboardType: TextInputType.number,
                  validator: Validators.idCard,
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
                RoomDropdown(
                  value: selectedRoomId,
                  rooms: rooms.cast(),
                  onChanged: (value) => setState(() => selectedRoomId = value),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: moveInDateController,
                  label: 'วันที่เข้าอยู่',
                  readOnly: true,
                  validator: (value) =>
                      Validators.requiredField(value, label: 'วันที่เข้าอยู่'),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      moveInDateController.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(picked);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  items: const [
                    DropdownMenuItem(value: 'active', child: Text('กำลังเช่า')),
                    DropdownMenuItem(
                      value: 'inactive',
                      child: Text('ย้ายออกแล้ว'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => status = value ?? 'active'),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => PrimaryButton(
                    onPressed: _submit,
                    label: 'บันทึกข้อมูล',
                    isLoading: controller.isSubmitting.value,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;
    final success = await controller.saveTenant(
      TenantModel(
        id: tenant?.id,
        prefix: prefixController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        idCard: idCardController.text.trim(),
        address: addressController.text.trim(),
        roomId: selectedRoomId!,
        moveInDate: moveInDateController.text.trim(),
        moveOutDate: tenant?.moveOutDate,
        status: status,
      ),
      previousRoomId: tenant?.roomId,
    );
    if (success) {
      Get.snackbar('สำเร็จ', 'บันทึกข้อมูลผู้เช่าเรียบร้อยแล้ว');
      Get.back();
    } else {
      Get.snackbar('เกิดข้อผิดพลาด', controller.errorMessage.value);
    }
  }
}
