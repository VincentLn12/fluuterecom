import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bill_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../routes/app_routes.dart';
import '../../models/room_model.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/status_chip.dart';

class RoomDetailView extends StatelessWidget {
  const RoomDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final room = ModalRoute.of(context)!.settings.arguments as RoomModel;
    return Scaffold(
      appBar: AppBar(title: Text('ห้อง ${room.roomNumber}')),
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
                          'ห้อง ${room.roomNumber}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      StatusChip(label: room.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('ประเภทห้อง: ${room.roomType}'),
                  Text('ชั้น: ${room.floor}'),
                  Text(
                    'ค่าเช่า: ${CurrencyFormatter.format(room.monthlyRent)}',
                  ),
                  Text('ค่าประกัน: ${CurrencyFormatter.format(room.deposit)}'),
                  const SizedBox(height: 8),
                  Text(room.description.isEmpty ? '-' : room.description),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: room.status == 'occupied'
                          ? () {
                              Get.find<BillController>()
                                  .prepareCreateBillFromRoom(room.id!);
                              Get.find<NavigationController>().changePage(3);
                              Get.until(
                                (route) =>
                                    route.settings.name == AppRoutes.main,
                              );
                            }
                          : null,
                      icon: const Icon(Icons.receipt_long_outlined),
                      label: const Text('ไปสร้างบิลจากห้องนี้'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
