import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'auth_controller.dart';
import '../models/bill_model.dart';
import '../models/room_model.dart';
import '../models/settings_model.dart';
import '../models/tenant_model.dart';
import '../models/utility_meter_model.dart';
import '../services/bill_service.dart';
import '../services/room_service.dart';
import '../services/settings_service.dart';
import '../services/tenant_service.dart';
import '../services/utility_meter_service.dart';

class BillController extends GetxController {
  final BillService billService;
  final RoomService roomService;
  final TenantService tenantService;
  final UtilityMeterService meterService;
  final SettingsService settingsService;

  BillController({
    required this.billService,
    required this.roomService,
    required this.tenantService,
    required this.meterService,
    required this.settingsService,
  });

  final bills = <BillModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;
  final searchText = ''.obs;
  final selectedMonth = ''.obs;
  final selectedStatus = 'all'.obs;

  final rooms = <RoomModel>[].obs;
  final tenants = <TenantModel>[].obs;
  final meters = <UtilityMeterModel>[].obs;
  final settings = Rxn<SettingsModel>();
  final pendingCreateRoomId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      bills.value = await billService.getBills();
      rooms.value = await roomService.getRooms();
      tenants.value = await tenantService.getTenants();
      meters.value = await meterService.getMeters();
      settings.value = await settingsService.getSettings();
      await refreshOverdueBills();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOverdueBills() async {
    final today = DateTime.now();
    for (final bill in bills) {
      if (bill.status == 'paid') continue;
      final due = DateTime.tryParse(bill.dueDate);
      if (due != null &&
          due.isBefore(DateTime(today.year, today.month, today.day))) {
        await billService.patchBill(bill.id!, {'status': 'overdue'});
      }
    }
    bills.value = await billService.getBills();
  }

  List<BillModel> get filteredBills {
    final authController = Get.find<AuthController>();
    final keyword = searchText.value.trim().toLowerCase();
    return bills.where((bill) {
      if (authController.isTenant &&
          bill.tenantId != authController.currentUser.value?.tenantId) {
        return false;
      }
      final room = rooms.firstWhereOrNull((item) => item.id == bill.roomId);
      final tenant = tenants.firstWhereOrNull(
        (item) => item.id == bill.tenantId,
      );
      final matchesSearch =
          keyword.isEmpty ||
          (room?.roomNumber.toLowerCase().contains(keyword) ?? false) ||
          (tenant?.fullName.toLowerCase().contains(keyword) ?? false);
      final matchesMonth =
          selectedMonth.value.isEmpty ||
          bill.billingMonth == selectedMonth.value;
      final matchesStatus =
          selectedStatus.value == 'all' || bill.status == selectedStatus.value;
      return matchesSearch && matchesMonth && matchesStatus;
    }).toList();
  }

  BillModel resolveCurrentBill(BillModel bill) {
    if (bill.id != null) {
      final matched = bills.firstWhereOrNull((item) => item.id == bill.id);
      if (matched != null) {
        return matched;
      }
    }

    return bills.firstWhereOrNull(
          (item) =>
              item.roomId == bill.roomId &&
              item.tenantId == bill.tenantId &&
              item.billingMonth == bill.billingMonth,
        ) ??
        bill;
  }

  UtilityMeterModel? latestPreviousMeter({
    required int roomId,
    required String billingMonth,
  }) {
    final items =
        meters
            .where(
              (item) =>
                  item.roomId == roomId &&
                  item.month.compareTo(billingMonth) < 0,
            )
            .toList()
          ..sort((a, b) => b.month.compareTo(a.month));
    return items.isEmpty ? null : items.first;
  }

  UtilityMeterModel? meterForRoomMonth({
    required int roomId,
    required String billingMonth,
  }) {
    final matches =
        meters
            .where(
              (item) => item.roomId == roomId && item.month == billingMonth,
            )
            .toList()
          ..sort((a, b) {
            final left = a.id ?? -1;
            final right = b.id ?? -1;
            return right.compareTo(left);
          });
    return matches.firstWhereOrNull((item) => item.id != null) ??
        matches.firstWhereOrNull((_) => true);
  }

  void prepareCreateBillFromRoom(int roomId) {
    pendingCreateRoomId.value = roomId;
  }

  DateTime _resolveDueDate(String billingMonth) {
    final parts = billingMonth.split('-');
    final year = parts.isNotEmpty
        ? int.tryParse(parts[0]) ?? DateTime.now().year
        : DateTime.now().year;
    final month = parts.length > 1
        ? int.tryParse(parts[1]) ?? DateTime.now().month
        : DateTime.now().month;
    final dueDay = settings.value?.defaultDueDay ?? 10;
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;
    final safeDay = dueDay > lastDayOfMonth ? lastDayOfMonth : dueDay;
    return DateTime(year, month, safeDay);
  }

  Future<BillModel> buildBillDraft({
    required int roomId,
    required String billingMonth,
    double otherAmount = 0,
    double lateFee = 0,
  }) async {
    final room = rooms.firstWhere((item) => item.id == roomId);
    final tenant = tenants.firstWhere(
      (item) => item.roomId == roomId && item.isActive,
      orElse: () => throw 'ไม่พบผู้เช่าปัจจุบันของห้องนี้',
    );
    final meter = meters.firstWhere(
      (item) => item.roomId == roomId && item.month == billingMonth,
      orElse: () => throw 'ไม่พบข้อมูลมิเตอร์ของเดือนนี้',
    );
    final duplicate = bills.any(
      (item) => item.roomId == roomId && item.billingMonth == billingMonth,
    );
    if (duplicate) throw 'มีบิลของห้องและเดือนนี้แล้ว';

    final total =
        room.monthlyRent +
        meter.waterAmount +
        meter.electricAmount +
        otherAmount +
        lateFee;
    final dueDate = DateFormat(
      'yyyy-MM-dd',
    ).format(_resolveDueDate(billingMonth));

    return BillModel(
      roomId: roomId,
      tenantId: tenant.id!,
      utilityMeterId: meter.id!,
      billingMonth: billingMonth,
      roomRent: room.monthlyRent,
      waterAmount: meter.waterAmount,
      electricAmount: meter.electricAmount,
      otherAmount: otherAmount,
      lateFee: lateFee,
      totalAmount: total,
      dueDate: dueDate,
      paidDate: null,
      paymentMethod: null,
      status: 'pending',
    );
  }

  Future<bool> createBillFromRoom({
    required int roomId,
    required String billingMonth,
    required double currentWater,
    required double currentElectric,
    double otherAmount = 0,
    double lateFee = 0,
    double? waterRate,
    double? electricRate,
  }) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      final room = rooms.firstWhere((item) => item.id == roomId);
      final tenant = tenants.firstWhere(
        (item) => item.roomId == roomId && item.isActive,
        orElse: () => throw 'ไม่พบผู้เช่าปัจจุบันของห้องนี้',
      );
      final tenantId = tenant.id;
      if (tenantId == null) {
        throw 'ข้อมูลผู้เช่าไม่สมบูรณ์ กรุณาตรวจสอบ tenant id';
      }

      final duplicateBill = bills.any(
        (item) => item.roomId == roomId && item.billingMonth == billingMonth,
      );
      if (duplicateBill) throw 'มีบิลของห้องและเดือนนี้แล้ว';

      final previousMeter = latestPreviousMeter(
        roomId: roomId,
        billingMonth: billingMonth,
      );
      final matchedMeter = meterForRoomMonth(
        roomId: roomId,
        billingMonth: billingMonth,
      );
      final existingMeter = matchedMeter?.id == null ? null : matchedMeter;

      final previousWater =
          existingMeter?.previousWater ?? previousMeter?.currentWater ?? 0;
      final previousElectric =
          existingMeter?.previousElectric ??
          previousMeter?.currentElectric ??
          0;
      final resolvedWaterRate =
          waterRate ??
          existingMeter?.waterRate ??
          previousMeter?.waterRate ??
          settings.value?.waterRate ??
          18;
      final resolvedElectricRate =
          electricRate ??
          existingMeter?.electricRate ??
          previousMeter?.electricRate ??
          settings.value?.electricRate ??
          8;

      if (currentWater < previousWater) {
        throw 'มิเตอร์น้ำปัจจุบันต้องไม่น้อยกว่าครั้งก่อน';
      }
      if (currentElectric < previousElectric) {
        throw 'มิเตอร์ไฟปัจจุบันต้องไม่น้อยกว่าครั้งก่อน';
      }

      final waterUnits = currentWater - previousWater;
      final electricUnits = currentElectric - previousElectric;
      final waterAmount = waterUnits * resolvedWaterRate;
      final electricAmount = electricUnits * resolvedElectricRate;

      final meterPayload = UtilityMeterModel(
        id: existingMeter?.id,
        roomId: roomId,
        month: billingMonth,
        previousWater: previousWater,
        currentWater: currentWater,
        previousElectric: previousElectric,
        currentElectric: currentElectric,
        waterRate: resolvedWaterRate,
        electricRate: resolvedElectricRate,
        waterUnits: waterUnits,
        electricUnits: electricUnits,
        waterAmount: waterAmount,
        electricAmount: electricAmount,
      );

      final savedMeter = existingMeter == null
          ? await meterService.createMeter(meterPayload)
          : await meterService.updateMeter(meterPayload);
      final savedMeterId =
          savedMeter.id ??
          (await _resolvePersistedMeterId(
            roomId: roomId,
            billingMonth: billingMonth,
          ));
      if (savedMeterId == null) {
        throw 'บันทึกมิเตอร์สำเร็จไม่สมบูรณ์ กรุณารีสตาร์ต json-server แล้วลองใหม่';
      }

      final total =
          room.monthlyRent +
          waterAmount +
          electricAmount +
          otherAmount +
          lateFee;
      final dueDate = DateFormat(
        'yyyy-MM-dd',
      ).format(_resolveDueDate(billingMonth));

      await billService.createBill(
        BillModel(
          roomId: roomId,
          tenantId: tenantId,
          utilityMeterId: savedMeterId,
          billingMonth: billingMonth,
          roomRent: room.monthlyRent,
          waterAmount: waterAmount,
          electricAmount: electricAmount,
          otherAmount: otherAmount,
          lateFee: lateFee,
          totalAmount: total,
          dueDate: dueDate,
          paidDate: null,
          paymentMethod: null,
          status: 'pending',
        ),
      );

      await fetchData();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<int?> _resolvePersistedMeterId({
    required int roomId,
    required String billingMonth,
  }) async {
    final latestMeters = await meterService.getMeters();
    meters.value = latestMeters;
    return latestMeters
        .where((item) => item.roomId == roomId && item.month == billingMonth)
        .map((item) => item.id)
        .whereType<int>()
        .fold<int?>(null, (best, current) {
          if (best == null || current > best) {
            return current;
          }
          return best;
        });
  }

  Future<bool> saveBill(BillModel bill) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      final duplicate = bills.any(
        (item) =>
            item.roomId == bill.roomId &&
            item.billingMonth == bill.billingMonth &&
            item.id != bill.id,
      );
      if (duplicate) throw 'มีบิลของห้องและเดือนนี้แล้ว';
      if (bill.id == null) {
        await billService.createBill(bill);
      } else {
        await billService.updateBill(bill);
      }
      await fetchData();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> markBillPaid(BillModel bill, String paymentMethod) async {
    try {
      isSubmitting.value = true;
      await billService.patchBill(bill.id!, {
        'status': 'paid',
        'paymentMethod': paymentMethod,
        'paidDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      });
      await fetchData();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteBill(int id) async {
    try {
      isSubmitting.value = true;
      await billService.deleteBill(id);
      await fetchData();
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
