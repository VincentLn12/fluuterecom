import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/tenant_controller.dart';
import '../../models/tenant_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/search_text_field.dart';
import '../../widgets/status_chip.dart';

class TenantListView extends StatefulWidget {
  const TenantListView({super.key});

  @override
  State<TenantListView> createState() => _TenantListViewState();
}

class _TenantListViewState extends State<TenantListView> {
  final controller = Get.find<TenantController>();
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('จัดการผู้เช่า')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.tenantForm),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingWidget();
        if (controller.errorMessage.value.isNotEmpty &&
            controller.tenants.isEmpty) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchTenants,
          );
        }

        final tenants = controller.filteredTenants;
        return RefreshIndicator(
          onRefresh: controller.fetchTenants,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SearchTextField(
                controller: searchController,
                hintText: 'ค้นหาชื่อหรือเบอร์โทร',
                onChanged: (value) => controller.searchText.value = value,
              ),
              const SizedBox(height: 16),
              if (tenants.isEmpty)
                const SizedBox(
                  height: 300,
                  child: EmptyState(title: 'ยังไม่มีข้อมูลผู้เช่า'),
                ),
              ...tenants.map((tenant) => _TenantCard(tenant: tenant)),
            ],
          ),
        );
      }),
    );
  }
}

class _TenantCard extends StatelessWidget {
  final TenantModel tenant;

  const _TenantCard({required this.tenant});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TenantController>();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => Get.toNamed(AppRoutes.tenantDetail, arguments: tenant),
        title: Text(tenant.fullName),
        subtitle: Text('${tenant.phone} • ห้อง ${tenant.roomId}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusChip(label: tenant.status),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  Get.toNamed(AppRoutes.tenantForm, arguments: tenant);
                } else if (value == 'moveout') {
                  final success = await controller.markTenantMovedOut(
                    tenant,
                    DateTime.now().toIso8601String().split('T').first,
                  );
                  if (success) {
                    Get.snackbar('สำเร็จ', 'บันทึกการย้ายออกเรียบร้อยแล้ว');
                  }
                } else {
                  Get.dialog(
                    ConfirmDeleteDialog(
                      title: 'ลบผู้เช่า',
                      content: 'ต้องการลบข้อมูล ${tenant.fullName} ใช่หรือไม่',
                      onConfirm: () async {
                        await controller.deleteTenant(tenant);
                      },
                    ),
                  );
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('แก้ไข')),
                PopupMenuItem(value: 'moveout', child: Text('ย้ายออก')),
                PopupMenuItem(value: 'delete', child: Text('ลบ')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
