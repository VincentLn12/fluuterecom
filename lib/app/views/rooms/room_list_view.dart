import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_theme.dart';
import '../../controllers/room_controller.dart';
import '../../models/room_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/search_text_field.dart';
import '../../widgets/status_chip.dart';

class RoomListView extends StatefulWidget {
  const RoomListView({super.key});

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  final RoomController controller = Get.find<RoomController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('จัดการห้องพัก'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.roomForm),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'เพิ่มห้องพัก',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingWidget();
        if (controller.errorMessage.value.isNotEmpty &&
            controller.rooms.isEmpty) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchRooms,
          );
        }

        final rooms = controller.filteredRooms;
        return RefreshIndicator(
          onRefresh: controller.fetchRooms,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Search field
              SearchTextField(
                controller: searchController,
                hintText: 'ค้นหาหมายเลขห้อง...',
                onChanged: (value) => controller.searchText.value = value,
              ),
              const SizedBox(height: 12),
              
              // Filters Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: controller.selectedStatus.value,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('ทุกสถานะ')),
                        DropdownMenuItem(value: 'vacant', child: Text('ว่าง')),
                        DropdownMenuItem(value: 'occupied', child: Text('มีผู้เช่า')),
                        DropdownMenuItem(value: 'reserved', child: Text('จอง')),
                        DropdownMenuItem(value: 'maintenance', child: Text('ซ่อมบำรุง')),
                      ],
                      onChanged: (value) =>
                          controller.selectedStatus.value = value ?? 'all',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: controller.selectedFloor.value,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: 0,
                          child: Text('ทุกชั้น'),
                        ),
                        ...{
                          for (final room in controller.rooms) room.floor,
                        }.map(
                          (floor) => DropdownMenuItem(
                            value: floor,
                            child: Text('ชั้น $floor'),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          controller.selectedFloor.value = value ?? 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Status Counters Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _CountChip(
                      label: 'ว่าง: ${controller.countByStatus('vacant')}',
                      color: AppTheme.success,
                    ),
                    const SizedBox(width: 8),
                    _CountChip(
                      label: 'มีผู้เช่า: ${controller.countByStatus('occupied')}',
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    _CountChip(
                      label: 'จอง: ${controller.countByStatus('reserved')}',
                      color: AppTheme.warning,
                    ),
                    const SizedBox(width: 8),
                    _CountChip(
                      label: 'ซ่อมบำรุง: ${controller.countByStatus('maintenance')}',
                      color: AppTheme.danger,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              if (rooms.isEmpty)
                const SizedBox(
                  height: 300,
                  child: EmptyState(title: 'ยังไม่มีข้อมูลห้องพัก'),
                ),
              
              if (rooms.isNotEmpty) ...[
                Builder(
                  builder: (context) {
                    // Group rooms by floor
                    final Map<int, List<RoomModel>> roomsByFloor = {};
                    for (final room in rooms) {
                      roomsByFloor.putIfAbsent(room.floor, () => []).add(room);
                    }
                    // Sort floor numbers
                    final sortedFloors = roomsByFloor.keys.toList()..sort();

                    return Column(
                      children: sortedFloors.map((floor) {
                        final floorRooms = roomsByFloor[floor] ?? [];
                        
                        // Calculate stats for this floor
                        final total = floorRooms.length;
                        final vacant = floorRooms.where((r) => r.status == 'vacant').length;
                        final occupied = floorRooms.where((r) => r.status == 'occupied').length;
                        final reserved = floorRooms.where((r) => r.status == 'reserved').length;
                        final maintenance = floorRooms.where((r) => r.status == 'maintenance').length;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade100, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.layers_outlined,
                                  color: AppTheme.primary,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                'ชั้นที่ $floor',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                'ทั้งหมด $total ห้อง • ว่าง $vacant • ผู้เช่า $occupied • จอง $reserved • ซ่อม $maintenance',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                              children: floorRooms.map(
                                (room) => _RoomCard(controller: controller, room: room),
                              ).toList(),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final RoomController controller;
  final RoomModel room;

  const _RoomCard({required this.controller, required this.room});

  @override
  Widget build(BuildContext context) {
    // Resolve colors based on status
    Color statusColor;
    switch (room.status) {
      case 'vacant':
        statusColor = AppTheme.success;
        break;
      case 'occupied':
        statusColor = AppTheme.primary;
        break;
      case 'reserved':
        statusColor = AppTheme.warning;
        break;
      case 'maintenance':
        statusColor = AppTheme.danger;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100, width: 1.2),
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
          onTap: () => Get.toNamed(AppRoutes.roomDetail, arguments: room),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Badge
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.meeting_room_rounded,
                      color: statusColor,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Room details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ห้อง ${room.roomNumber}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${room.roomType} • ชั้น ${room.floor}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(room.monthlyRent),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status Badge & Menu
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatusChip(label: room.status),
                    const SizedBox(width: 4),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          Get.toNamed(AppRoutes.roomForm, arguments: room);
                        } else {
                          Get.dialog(
                            ConfirmDeleteDialog(
                              title: 'ลบห้องพัก',
                              content: 'ต้องการลบห้อง ${room.roomNumber} ใช่หรือไม่',
                              onConfirm: () async {
                                await controller.deleteRoom(room.id!);
                              },
                            ),
                          );
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('แก้ไข'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: AppTheme.danger, size: 18),
                              SizedBox(width: 8),
                              Text('ลบ', style: TextStyle(color: AppTheme.danger)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final String label;
  final Color color;

  const _CountChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
