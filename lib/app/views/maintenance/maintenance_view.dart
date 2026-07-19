import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/maintenance_controller.dart';
import '../../controllers/tenant_controller.dart';
import '../../models/maintenance_request_model.dart';
import '../../utils/date_formatter.dart';
import '../../utils/validators.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_chip.dart';

class MaintenanceView extends GetView<MaintenanceController> {
  final bool isTenantMode;

  const MaintenanceView({super.key, this.isTenantMode = false});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final tenantController = Get.find<TenantController>();
    return Scaffold(
      appBar: AppBar(title: Text(isTenantMode ? 'แจ้งซ่อมของฉัน' : 'แจ้งซ่อม')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingWidget();
        if (controller.errorMessage.value.isNotEmpty &&
            controller.requests.isEmpty) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchRequests,
          );
        }
        final tenantId = authController.currentUser.value?.tenantId;
        final tenant = tenantController.tenants.firstWhereOrNull(
          (item) => item.id == tenantId,
        );
        final requests = isTenantMode && tenant != null
            ? controller.filteredRequests
                  .where((item) => item.roomId == tenant.roomId)
                  .toList()
            : controller.filteredRequests;
        return RefreshIndicator(
          onRefresh: controller.fetchRequests,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (!isTenantMode) ...[
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'ค้นหาห้องหรือหัวข้อ',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => controller.searchText.value = value,
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: controller.selectedPriority.value,
                      items: const [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text('ทุกความเร่งด่วน'),
                        ),
                        DropdownMenuItem(value: 'low', child: Text('ต่ำ')),
                        DropdownMenuItem(
                          value: 'medium',
                          child: Text('ปานกลาง'),
                        ),
                        DropdownMenuItem(value: 'high', child: Text('สูง')),
                      ],
                      onChanged: (value) =>
                          controller.selectedPriority.value = value ?? 'all',
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
                          value: 'in_progress',
                          child: Text('กำลังดำเนินการ'),
                        ),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text('เสร็จสิ้น'),
                        ),
                        DropdownMenuItem(
                          value: 'cancelled',
                          child: Text('ยกเลิก'),
                        ),
                      ],
                      onChanged: (value) =>
                          controller.selectedStatus.value = value ?? 'all',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (requests.isEmpty)
                const SizedBox(
                  height: 300,
                  child: EmptyState(title: 'ยังไม่มีรายการแจ้งซ่อม'),
                ),
              ...requests.map((request) => _RequestCard(request: request)),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _showForm({MaintenanceRequestModel? request}) async {
    final authController = Get.find<AuthController>();
    final tenantController = Get.find<TenantController>();
    final tenantId = authController.currentUser.value?.tenantId;
    final tenant = tenantController.tenants.firstWhereOrNull(
      (item) => item.id == tenantId,
    );
    final formKey = GlobalKey<FormState>();
    final roomController = TextEditingController(
      text: request?.roomId.toString() ?? tenant?.roomId.toString() ?? '',
    );
    final titleController = TextEditingController(text: request?.title ?? '');
    final descriptionController = TextEditingController(
      text: request?.description ?? '',
    );
    String priority = request?.priority ?? 'medium';
    String status = request?.status ?? 'pending';

    await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: roomController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Room ID'),
                  readOnly: isTenantMode,
                  validator: (value) =>
                      Validators.requiredField(value, label: 'หมายเลขห้อง'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'หัวข้อ'),
                  validator: (value) =>
                      Validators.requiredField(value, label: 'หัวข้อ'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'รายละเอียด'),
                  validator: (value) =>
                      Validators.requiredField(value, label: 'รายละเอียด'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: priority,
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('ต่ำ')),
                    DropdownMenuItem(value: 'medium', child: Text('ปานกลาง')),
                    DropdownMenuItem(value: 'high', child: Text('สูง')),
                  ],
                  onChanged: (value) => priority = value ?? 'medium',
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  items: const [
                    DropdownMenuItem(
                      value: 'pending',
                      child: Text('รอดำเนินการ'),
                    ),
                    DropdownMenuItem(
                      value: 'in_progress',
                      child: Text('กำลังดำเนินการ'),
                    ),
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('เสร็จสิ้น'),
                    ),
                    DropdownMenuItem(value: 'cancelled', child: Text('ยกเลิก')),
                  ],
                  onChanged: (value) => status = value ?? 'pending',
                ),
                const SizedBox(height: 20),
                Obx(
                  () => PrimaryButton(
                    isLoading: controller.isSubmitting.value,
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final success = await controller.saveRequest(
                        MaintenanceRequestModel(
                          id: request?.id,
                          roomId: int.parse(roomController.text.trim()),
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          priority: priority,
                          status: status,
                          createdAt:
                              request?.createdAt ??
                              DateFormat(
                                "yyyy-MM-dd'T'HH:mm:ss",
                              ).format(DateTime.now()),
                          completedAt: status == 'completed'
                              ? DateFormat(
                                  "yyyy-MM-dd'T'HH:mm:ss",
                                ).format(DateTime.now())
                              : null,
                        ),
                      );
                      if (success) {
                        Get.back();
                        Get.snackbar(
                          'สำเร็จ',
                          'บันทึกข้อมูลแจ้งซ่อมเรียบร้อยแล้ว',
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
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _RequestCard extends StatelessWidget {
  final MaintenanceRequestModel request;

  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MaintenanceController>();
    final authController = Get.find<AuthController>();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(request.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ห้อง ${request.roomId} • ${DateFormatter.display(request.createdAt)}',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusChip(label: request.priority),
                StatusChip(label: request.status),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        trailing: authController.isOwner
            ? PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    MaintenanceView()._showForm(request: request);
                  } else if (value == 'status') {
                    await controller.updateMaintenanceStatus(
                      request,
                      request.status == 'pending' ? 'in_progress' : 'completed',
                    );
                  } else {
                    Get.dialog(
                      ConfirmDeleteDialog(
                        title: 'ลบรายการแจ้งซ่อม',
                        content: 'ต้องการลบรายการนี้ใช่หรือไม่',
                        onConfirm: () async =>
                            controller.deleteRequest(request.id!),
                      ),
                    );
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('แก้ไข')),
                  PopupMenuItem(value: 'status', child: Text('เปลี่ยนสถานะ')),
                  PopupMenuItem(value: 'delete', child: Text('ลบ')),
                ],
                icon: const Icon(Icons.more_vert),
              )
            : null,
      ),
    );
  }
}
