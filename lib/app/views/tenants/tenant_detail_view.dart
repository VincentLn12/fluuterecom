import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/room_controller.dart';
import '../../controllers/tenant_controller.dart';
import '../../models/tenant_model.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/status_chip.dart';

class TenantDetailView extends StatelessWidget {
  final int? tenantId;

  const TenantDetailView({super.key, this.tenantId});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final roomController = Get.find<RoomController>();
    const fallbackTenant = TenantModel(
      id: null,
      prefix: '',
      firstName: 'ไม่พบข้อมูล',
      lastName: '',
      phone: '-',
      email: '-',
      idCard: '-',
      address: '-',
      roomId: 0,
      moveInDate: '-',
      moveOutDate: null,
      status: 'inactive',
    );

    final routeTenant = Get.arguments is TenantModel
        ? Get.arguments as TenantModel
        : null;
    final tenant = tenantId != null
        ? Get.find<TenantController>().tenants.firstWhereOrNull(
                (item) => item.id == tenantId,
              ) ??
              routeTenant ??
              fallbackTenant
        : routeTenant ?? fallbackTenant;
    final room = roomController.rooms.firstWhereOrNull(
      (item) => item.id == tenant.roomId,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์ผู้เช่า'),
        actions: tenantId != null
            ? [
                IconButton(
                  onPressed: () {
                    authController.logout();
                    Get.offAllNamed('/login');
                  },
                  icon: const Icon(Icons.logout),
                ),
              ]
            : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tenant.fullName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      StatusChip(label: tenant.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(label: 'เบอร์โทร', value: tenant.phone),
                  _InfoRow(label: 'อีเมล', value: tenant.email),
                  _InfoRow(label: 'เลขบัตรประชาชน', value: tenant.idCard),
                  _InfoRow(label: 'ห้องพัก', value: room?.roomNumber ?? '-'),
                  _InfoRow(label: 'ประเภทห้อง', value: room?.roomType ?? '-'),
                  _InfoRow(
                    label: 'ค่าเช่ารายเดือน',
                    value: room == null
                        ? '-'
                        : CurrencyFormatter.format(room.monthlyRent),
                  ),
                  _InfoRow(label: 'วันที่เข้าอยู่', value: tenant.moveInDate),
                  if (tenant.moveOutDate != null)
                    _InfoRow(
                      label: 'วันที่ย้ายออก',
                      value: tenant.moveOutDate!,
                    ),
                  const SizedBox(height: 8),
                  Text(tenant.address),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
