import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/bill_controller.dart';
import '../../models/bill_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/month_picker_field.dart';
import '../../widgets/room_dropdown.dart';
import '../../widgets/status_chip.dart';

class BillListView extends GetView<BillController> {
  BillListView({super.key});

  final monthController = TextEditingController();
  final filterMonthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final pendingRoomId = controller.pendingCreateRoomId.value;
    if (authController.isOwner && pendingRoomId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.pendingCreateRoomId.value == pendingRoomId) {
          controller.pendingCreateRoomId.value = null;
          _openCreateBillDialog(context, initialRoomId: pendingRoomId);
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(authController.isOwner ? 'จัดการบิล' : 'บิลของฉัน'),
        actions: authController.isTenant
            ? [
                IconButton(
                  onPressed: () {
                    authController.logout();
                    Get.offAllNamed(AppRoutes.login);
                  },
                  icon: const Icon(Icons.logout),
                ),
              ]
            : null,
      ),
      floatingActionButton: authController.isOwner
          ? FloatingActionButton.extended(
              onPressed: () => _openCreateBillDialog(context),
              label: const Text('สร้างบิล'),
              icon: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingWidget();
        if (controller.errorMessage.value.isNotEmpty &&
            controller.bills.isEmpty) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchData,
          );
        }

        final bills = controller.filteredBills;
        return RefreshIndicator(
          onRefresh: controller.fetchData,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'ค้นหาห้องหรือชื่อผู้เช่า',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => controller.searchText.value = value,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: MonthPickerField(
                      controller: filterMonthController,
                      label: 'กรองตามเดือน',
                      validator: (_) => null,
                      helpText: 'เลือกเดือนสำหรับกรองบิล',
                      onChanged: (value) =>
                          controller.selectedMonth.value = value,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: controller.selectedStatus.value,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('ทุกสถานะ')),
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text('รอดำเนินการ'),
                        ),
                        DropdownMenuItem(
                          value: 'paid',
                          child: Text('ชำระแล้ว'),
                        ),
                        DropdownMenuItem(
                          value: 'overdue',
                          child: Text('ค้างชำระ'),
                        ),
                      ],
                      onChanged: (value) =>
                          controller.selectedStatus.value = value ?? 'all',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (bills.isEmpty)
                const SizedBox(
                  height: 280,
                  child: EmptyState(title: 'ยังไม่มีข้อมูลบิล'),
                ),
              ...bills.map((bill) => _BillCard(bill: bill)),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _openCreateBillDialog(
    BuildContext context, {
    int? initialRoomId,
  }) async {
    monthController.clear();
    int? selectedRoomId = initialRoomId;
    final currentWaterController = TextEditingController();
    final currentElectricController = TextEditingController();
    final otherAmountController = TextEditingController(text: '0');
    final lateFeeController = TextEditingController(text: '0');
    final availableRooms = controller.rooms.where((room) {
      return controller.tenants.any(
        (tenant) => tenant.roomId == room.id && tenant.isActive,
      );
    }).toList()..sort((a, b) => a.roomNumber.compareTo(b.roomNumber));

    await Get.dialog(
      AlertDialog(
        title: const Text('สร้างบิลใหม่'),
        content: StatefulBuilder(
          builder: (context, setState) {
            final currentMonthMeter =
                selectedRoomId != null && monthController.text.trim().isNotEmpty
                ? controller.meterForRoomMonth(
                    roomId: selectedRoomId!,
                    billingMonth: monthController.text.trim(),
                  )
                : null;
            final previousMeter =
                selectedRoomId != null && monthController.text.trim().isNotEmpty
                ? controller.latestPreviousMeter(
                    roomId: selectedRoomId!,
                    billingMonth: monthController.text.trim(),
                  )
                : null;
            final room = selectedRoomId == null
                ? null
                : availableRooms.firstWhereOrNull(
                    (item) => item.id == selectedRoomId,
                  );
            final previousWater =
                currentMonthMeter?.previousWater ??
                previousMeter?.currentWater ??
                0;
            final previousElectric =
                currentMonthMeter?.previousElectric ??
                previousMeter?.currentElectric ??
                0;
            final waterRate =
                currentMonthMeter?.waterRate ??
                previousMeter?.waterRate ??
                controller.settings.value?.waterRate ??
                18;
            final electricRate =
                currentMonthMeter?.electricRate ??
                previousMeter?.electricRate ??
                controller.settings.value?.electricRate ??
                8;

            if (currentMonthMeter != null &&
                currentWaterController.text.trim().isEmpty &&
                currentElectricController.text.trim().isEmpty) {
              currentWaterController.text = currentMonthMeter.currentWater
                  .toString();
              currentElectricController.text = currentMonthMeter.currentElectric
                  .toString();
            }

            final currentWater =
                double.tryParse(currentWaterController.text.trim()) ??
                previousWater;
            final currentElectric =
                double.tryParse(currentElectricController.text.trim()) ??
                previousElectric;
            final waterUnits = currentWater >= previousWater
                ? currentWater - previousWater
                : 0;
            final electricUnits = currentElectric >= previousElectric
                ? currentElectric - previousElectric
                : 0;
            final waterAmount = waterUnits * waterRate;
            final electricAmount = electricUnits * electricRate;

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoomDropdown(
                    value: selectedRoomId,
                    rooms: availableRooms,
                    label: 'เลือกเลขห้อง',
                    onChanged: (value) =>
                        setState(() => selectedRoomId = value),
                  ),
                  const SizedBox(height: 12),
                  MonthPickerField(
                    controller: monthController,
                    label: 'เดือนออกบิล',
                    helpText: 'เลือกเดือนออกบิล',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  if (room != null)
                    _ReadOnlyField(
                      label: 'ค่าเช่าห้อง',
                      value: CurrencyFormatter.format(room.monthlyRent),
                    ),
                  if (room != null) const SizedBox(height: 12),
                  _ReadOnlyField(
                    label: 'มิเตอร์น้ำครั้งก่อน',
                    value: '$previousWater',
                  ),
                  const SizedBox(height: 12),
                  _ReadOnlyField(
                    label: 'มิเตอร์ไฟครั้งก่อน',
                    value: '$previousElectric',
                  ),
                  const SizedBox(height: 12),
                  _ReadOnlyField(
                    label: 'ค่าน้ำต่อหน่วย',
                    value: CurrencyFormatter.format(waterRate),
                  ),
                  const SizedBox(height: 12),
                  _ReadOnlyField(
                    label: 'ค่าไฟต่อหน่วย',
                    value: CurrencyFormatter.format(electricRate),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: currentWaterController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'มิเตอร์น้ำปัจจุบัน',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: currentElectricController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'มิเตอร์ไฟปัจจุบัน',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: otherAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ค่าใช้จ่ายอื่น ๆ',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: lateFeeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ค่าปรับ / ค่าบริการเพิ่ม',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ReadOnlyField(
                    label: 'ค่าน้ำที่คำนวณได้',
                    value:
                        '${waterUnits.toStringAsFixed(0)} หน่วย • ${CurrencyFormatter.format(waterAmount)}',
                  ),
                  const SizedBox(height: 12),
                  _ReadOnlyField(
                    label: 'ค่าไฟที่คำนวณได้',
                    value:
                        '${electricUnits.toStringAsFixed(0)} หน่วย • ${CurrencyFormatter.format(electricAmount)}',
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('ยกเลิก')),
          FilledButton(
            onPressed: () async {
              if (selectedRoomId == null) {
                Get.snackbar('ข้อมูลไม่ครบ', 'กรุณาเลือกเลขห้อง');
                return;
              }
              if (monthController.text.trim().isEmpty) {
                Get.snackbar('ข้อมูลไม่ครบ', 'กรุณาเลือกเดือนออกบิล');
                return;
              }
              final currentWater = double.tryParse(
                currentWaterController.text.trim(),
              );
              final currentElectric = double.tryParse(
                currentElectricController.text.trim(),
              );
              if (currentWater == null || currentElectric == null) {
                Get.snackbar('ข้อมูลไม่ครบ', 'กรุณากรอกมิเตอร์ปัจจุบันให้ครบ');
                return;
              }
              final otherAmount =
                  double.tryParse(otherAmountController.text.trim()) ?? 0;
              final lateFee =
                  double.tryParse(lateFeeController.text.trim()) ?? 0;

              final success = await controller.createBillFromRoom(
                roomId: selectedRoomId!,
                billingMonth: monthController.text.trim(),
                currentWater: currentWater,
                currentElectric: currentElectric,
                otherAmount: otherAmount,
                lateFee: lateFee,
              );
              if (success) {
                Get.back();
                Get.snackbar('สำเร็จ', 'สร้างบิลเรียบร้อยแล้ว');
              } else {
                Get.snackbar('เกิดข้อผิดพลาด', controller.errorMessage.value);
              }
            },
            child: const Text('สร้างบิล'),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _BillCard extends StatelessWidget {
  final BillModel bill;

  const _BillCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final controller = Get.find<BillController>();
    final room = controller.rooms.firstWhereOrNull(
      (item) => item.id == bill.roomId,
    );
    final tenant = controller.tenants.firstWhereOrNull(
      (item) => item.id == bill.tenantId,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.billDetail, arguments: bill),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Room Number Icon/Badge
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.receipt_outlined,
                      color: AppTheme.primary,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Billing Info details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ห้อง ${room?.roomNumber ?? bill.roomId} • ${tenant?.fullName ?? ''}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'รอบบิล: ${DateFormatter.formatBillingMonth(bill.billingMonth)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ยอดสุทธิ: ${CurrencyFormatter.format(bill.totalAmount)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Action Menu and Status Chip
                authController.isOwner
                    ? PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'pay') {
                            await _showPayDialog(controller, bill);
                          } else {
                            Get.dialog(
                              ConfirmDeleteDialog(
                                title: 'ลบบิล',
                                content: 'ต้องการลบบิลของห้องนี้ใช่หรือไม่',
                                onConfirm: () async =>
                                    controller.deleteBill(bill.id!),
                              ),
                            );
                          }
                        },
                        itemBuilder: (_) => [
                          if (!bill.isPaid)
                            const PopupMenuItem(
                              value: 'pay',
                              child: Text('ชำระเงิน'),
                            ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('ลบ'),
                          ),
                        ],
                        child: StatusChip(label: bill.status),
                      )
                    : StatusChip(label: bill.status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPayDialog(BillController controller, BillModel bill) async {
    String method = 'cash';
    await Get.dialog(
      AlertDialog(
        title: const Text('เลือกช่องทางชำระเงิน'),
        content: StatefulBuilder(
          builder: (context, setState) => DropdownButtonFormField<String>(
            initialValue: method,
            items: const [
              DropdownMenuItem(value: 'cash', child: Text('เงินสด')),
              DropdownMenuItem(
                value: 'bank_transfer',
                child: Text('โอนธนาคาร'),
              ),
              DropdownMenuItem(value: 'promptpay', child: Text('PromptPay')),
            ],
            onChanged: (value) => setState(() => method = value ?? 'cash'),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('ยกเลิก')),
          FilledButton(
            onPressed: () async {
              final success = await controller.markBillPaid(bill, method);
              if (success) {
                Get.back();
                Get.snackbar('สำเร็จ', 'บันทึกการชำระเงินเรียบร้อยแล้ว');
              }
            },
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }
}
