import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/room_controller.dart';
import '../../models/room_model.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/primary_button.dart';

class RoomFormView extends StatefulWidget {
  const RoomFormView({super.key});

  @override
  State<RoomFormView> createState() => _RoomFormViewState();
}

class _RoomFormViewState extends State<RoomFormView> {
  final controller = Get.find<RoomController>();
  final formKey = GlobalKey<FormState>();
  final room = Get.arguments as RoomModel?;

  late final TextEditingController roomNumberController;
  late final TextEditingController floorController;
  late final TextEditingController roomTypeController;
  late final TextEditingController monthlyRentController;
  late final TextEditingController depositController;
  late final TextEditingController descriptionController;
  late final TextEditingController imageUrlController;
  late String status;

  @override
  void initState() {
    super.initState();
    roomNumberController = TextEditingController(text: room?.roomNumber ?? '');
    floorController = TextEditingController(text: room?.floor.toString() ?? '');
    roomTypeController = TextEditingController(text: room?.roomType ?? '');
    monthlyRentController = TextEditingController(
      text: room?.monthlyRent.toString() ?? '',
    );
    depositController = TextEditingController(
      text: room?.deposit.toString() ?? '',
    );
    descriptionController = TextEditingController(
      text: room?.description ?? '',
    );
    imageUrlController = TextEditingController(text: room?.imageUrl ?? '');
    status = room?.status ?? 'vacant';
  }

  @override
  void dispose() {
    roomNumberController.dispose();
    floorController.dispose();
    roomTypeController.dispose();
    monthlyRentController.dispose();
    depositController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room == null ? 'เพิ่มห้องพัก' : 'แก้ไขห้องพัก'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: roomNumberController,
                  label: 'หมายเลขห้อง',
                  validator: (value) =>
                      Validators.requiredField(value, label: 'หมายเลขห้อง'),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: floorController,
                  label: 'ชั้น',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      Validators.requiredField(value, label: 'ชั้น'),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: roomTypeController,
                  label: 'ประเภทห้อง',
                  validator: (value) =>
                      Validators.requiredField(value, label: 'ประเภทห้อง'),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: monthlyRentController,
                  label: 'ค่าเช่ารายเดือน',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      Validators.nonNegative(value, label: 'ค่าเช่า'),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: depositController,
                  label: 'ค่าประกัน',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      Validators.nonNegative(value, label: 'ค่าประกัน'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  items: const [
                    DropdownMenuItem(value: 'vacant', child: Text('ว่าง')),
                    DropdownMenuItem(
                      value: 'occupied',
                      child: Text('มีผู้เช่า'),
                    ),
                    DropdownMenuItem(value: 'reserved', child: Text('จอง')),
                    DropdownMenuItem(
                      value: 'maintenance',
                      child: Text('ซ่อมบำรุง'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => status = value ?? 'vacant'),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: descriptionController,
                  label: 'รายละเอียด',
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: imageUrlController,
                  label: 'รูปภาพ URL',
                ),
                const SizedBox(height: 24),
                Obx(
                  () => PrimaryButton(
                    isLoading: controller.isSubmitting.value,
                    onPressed: _submit,
                    label: 'บันทึกข้อมูล',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;
    final success = await controller.saveRoom(
      RoomModel(
        id: room?.id,
        roomNumber: roomNumberController.text.trim(),
        floor: int.parse(floorController.text.trim()),
        roomType: roomTypeController.text.trim(),
        monthlyRent: double.parse(monthlyRentController.text.trim()),
        deposit: double.parse(depositController.text.trim()),
        status: status,
        description: descriptionController.text.trim(),
        imageUrl: imageUrlController.text.trim(),
      ),
    );
    if (success) {
      Get.snackbar('สำเร็จ', 'บันทึกข้อมูลห้องพักเรียบร้อยแล้ว');
      Get.back();
    } else {
      Get.snackbar('เกิดข้อผิดพลาด', controller.errorMessage.value);
    }
  }
}
