import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/bill_controller.dart';
import '../../controllers/maintenance_controller.dart';
import '../../controllers/room_controller.dart';
import '../../controllers/tenant_controller.dart';
import '../../models/tenant_model.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/summary_card.dart';

class TenantHomeView extends StatelessWidget {
  const TenantHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final tenantController = Get.find<TenantController>();
    final roomController = Get.find<RoomController>();
    final billController = Get.find<BillController>();
    final maintenanceController = Get.find<MaintenanceController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าหลักของฉัน'),
        actions: [
          IconButton(
            onPressed: () {
              authController.logout();
              Get.offAllNamed('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() {
        final tenantId = authController.currentUser.value?.tenantId;
        final tenant = tenantController.tenants.firstWhereOrNull(
          (item) => item.id == tenantId,
        );

        if (tenant == null) {
          return const EmptyState(
            title: 'ไม่พบข้อมูลผู้เช่า',
            message: 'บัญชีนี้ยังไม่ได้ผูกกับข้อมูลผู้เช่า',
          );
        }

        if (tenantController.isLoading.value ||
            roomController.isLoading.value ||
            billController.isLoading.value ||
            maintenanceController.isLoading.value) {
          return const LoadingWidget();
        }

        final room = roomController.rooms.firstWhereOrNull(
          (item) => item.id == tenant.roomId,
        );
        final myBills = billController.bills
            .where((item) => item.tenantId == tenant.id)
            .toList();
        final unpaidBills = myBills
            .where(
              (item) => item.status == 'pending' || item.status == 'overdue',
            )
            .toList();
        final latestBill = myBills.isEmpty ? null : myBills.last;
        final myRequests = maintenanceController.requests
            .where((item) => item.roomId == tenant.roomId)
            .toList();

        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              tenantController.fetchTenants(),
              roomController.fetchRooms(),
              billController.fetchData(),
              maintenanceController.fetchRequests(),
            ]);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _WelcomeCard(tenant: tenant, roomNumber: room?.roomNumber ?? '-'),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SummaryCard(
                    title: 'ห้องของฉัน',
                    value: room?.roomNumber ?? '-',
                    icon: Icons.meeting_room_outlined,
                    color: AppTheme.primary,
                  ),
                  SummaryCard(
                    title: 'บิลค้างชำระ',
                    value: '${unpaidBills.length}',
                    icon: Icons.receipt_long_outlined,
                    color: AppTheme.danger,
                  ),
                  SummaryCard(
                    title: 'คำขอแจ้งซ่อม',
                    value: '${myRequests.length}',
                    icon: Icons.build_circle_outlined,
                    color: AppTheme.warning,
                  ),
                  SummaryCard(
                    title: 'ยอดล่าสุด',
                    value: latestBill == null
                        ? '-'
                        : CurrencyFormatter.format(latestBill.totalAmount),
                    icon: Icons.payments_outlined,
                    color: AppTheme.success,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'ข้อมูลห้องพัก',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      label: 'หมายเลขห้อง',
                      value: room?.roomNumber ?? '-',
                    ),
                    _InfoRow(label: 'ประเภทห้อง', value: room?.roomType ?? '-'),
                    _InfoRow(
                      label: 'ค่าเช่ารายเดือน',
                      value: room == null
                          ? '-'
                          : CurrencyFormatter.format(room.monthlyRent),
                    ),
                    _InfoRow(
                      label: 'สถานะการเช่า',
                      valueWidget: StatusChip(label: tenant.status),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'บิลล่าสุด',
                child: latestBill == null
                    ? const Text('ยังไม่มีข้อมูลบิล')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoRow(
                            label: 'รอบบิล',
                            value: DateFormatter.formatBillingMonth(latestBill.billingMonth),
                          ),
                          _InfoRow(
                            label: 'ยอดรวม',
                            value: CurrencyFormatter.format(
                              latestBill.totalAmount,
                            ),
                          ),
                          _InfoRow(
                            label: 'ครบกำหนด',
                            value: latestBill.dueDate,
                          ),
                          _InfoRow(
                            label: 'สถานะ',
                            valueWidget: StatusChip(label: latestBill.status),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'แจ้งซ่อมล่าสุด',
                child: myRequests.isEmpty
                    ? const Text('ยังไม่มีรายการแจ้งซ่อม')
                    : Column(
                        children: myRequests.take(3).map((request) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(child: Text(request.title)),
                                StatusChip(label: request.status),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final TenantModel tenant;
  final String roomNumber;

  const _WelcomeCard({required this.tenant, required this.roomNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สวัสดี ${tenant.fullName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('ห้องพักของคุณคือ ห้อง $roomNumber'),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;

  const _InfoRow({required this.label, this.value, this.valueWidget});

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
          if (valueWidget != null) valueWidget! else Text(value ?? '-'),
        ],
      ),
    );
  }
}
