import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/bill_model.dart';
import '../models/maintenance_request_model.dart';
import '../models/room_model.dart';
import '../services/bill_service.dart';
import '../services/maintenance_service.dart';
import '../services/room_service.dart';

class DashboardController extends GetxController {
  final RoomService roomService;
  final BillService billService;
  final MaintenanceService maintenanceService;

  DashboardController({
    required this.roomService,
    required this.billService,
    required this.maintenanceService,
  });

  final rooms = <RoomModel>[].obs;
  final bills = <BillModel>[].obs;
  final requests = <MaintenanceRequestModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      rooms.value = await roomService.getRooms();
      bills.value = await billService.getBills();
      requests.value = await maintenanceService.getRequests();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  int get totalRooms => rooms.length;
  int get vacantRooms => rooms.where((room) => room.status == 'vacant').length;
  int get occupiedRooms =>
      rooms.where((room) => room.status == 'occupied').length;
  int get maintenanceRooms =>
      rooms.where((room) => room.status == 'maintenance').length;
  int get pendingBills => bills
      .where((bill) => bill.status == 'pending' || bill.status == 'overdue')
      .length;
  int get openRequests =>
      requests.where((request) => request.status != 'completed').length;

  double get monthlyIncome {
    final month = DateFormat('yyyy-MM').format(DateTime.now());
    return bills
        .where((bill) => bill.status == 'paid' && bill.billingMonth == month)
        .fold(0.0, (sum, bill) => sum + bill.totalAmount);
  }
}
