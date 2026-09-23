import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../orders/models/order_model.dart';
import '../../shops/models/shop_model.dart';
import '../repositories/merchant_repository.dart';

class ManageOrdersController extends GetxController {
  final MerchantRepository _repository = Get.find<MerchantRepository>();

  final orders = <OrderModel>[].obs;
  final isLoading = true.obs;
  final selectedStatus = 'All'.obs;

  List<OrderModel> get filteredOrders {
    final status = selectedStatus.value;
    if (status == 'All' || status.isEmpty) return orders;

    return orders.where((o) {
      final orderStat = o.orderStatus.trim().toLowerCase();
      final payStat = o.paymentStatus.trim().toLowerCase();
      final targetStat = status.trim().toLowerCase();

      if (targetStat == 'pendingverification') {
        return payStat == 'pendingverification';
      } else if (targetStat == 'paid') {
        return payStat == 'paid' &&
            orderStat != 'shipped' &&
            orderStat != 'completed' &&
            orderStat != 'cancelled';
      } else if (targetStat == 'shipped') {
        return orderStat == 'shipped';
      } else if (targetStat == 'completed') {
        return orderStat == 'completed';
      } else if (targetStat == 'cancelled') {
        return orderStat == 'cancelled';
      }
      return orderStat == targetStat;
    }).toList();
  }

  final statusTabs = [
    {'value': 'All', 'label': 'ทั้งหมด'},
    {'value': 'Pending', 'label': 'รอยืนยันออเดอร์'},
    {'value': 'Confirmed', 'label': 'ยืนยันแล้ว'},
    {'value': 'Processing', 'label': 'เตรียมจัดส่ง'},
    {'value': 'Shipped', 'label': 'จัดส่งแล้ว'},
    {'value': 'Completed', 'label': 'สำเร็จ'},
    {'value': 'Cancelled', 'label': 'ยกเลิก'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  final Rx<ShopModel?> myShop = Rx<ShopModel?>(null);

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      final shop = await _repository.fetchMyShop();
      myShop.value = shop;
      if (shop != null) {
        final list = await _repository.fetchMerchantOrders();
        orders.value = list;
      } else {
        orders.clear();
      }
    } catch (e) {
      debugPrint('Error loading merchant orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeStatusTab(String status) {
    selectedStatus.value = status;
  }

  Future<void> submitShipmentFulfillment({
    required OrderModel order,
    required String carrierName,
    required String trackingNumber,
  }) async {
    if (carrierName.trim().isEmpty || trackingNumber.trim().isEmpty) {
      Get.snackbar(
        'กรอกข้อมูลไม่ครบ',
        'กรุณากรอกชื่อบริษัทขนส่ง และเลขติดตามพัสดุ (Tracking Number)',
        backgroundColor: Colors.amber.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final success = await _repository.updateShipment(
        order.id,
        carrierName.trim(),
        trackingNumber.trim(),
      );

      if (success) {
        Get.back();
        loadOrders();
        Get.snackbar(
          'บันทึกข้อมูลจัดส่งแล้ว',
          'บันทึกการจัดส่งและเลขพัสดุ $trackingNumber เรียบร้อยแล้ว',
          backgroundColor: const Color(0xFF047857),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถบันทึกข้อมูลจัดส่งได้ กรุณาลองใหม่อีกครั้ง',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        e.toString(),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> changeFulfillmentStatus(OrderModel order, String status) async {
    final current = order.orderStatus.toLowerCase();
    final allowed =
        (current == 'pending' &&
            (status == 'Confirmed' || status == 'Cancelled')) ||
        (current == 'confirmed' && status == 'Processing');
    if (!allowed) return;
    final success = await _repository.updateOrderStatus(order.id, status);
    if (success) {
      await loadOrders();
      Get.snackbar(
        'อัปเดตออเดอร์แล้ว',
        status == 'Confirmed'
            ? 'ยืนยันออเดอร์แล้ว'
            : status == 'Processing'
            ? 'เริ่มเตรียมจัดส่งแล้ว'
            : 'ยกเลิกออเดอร์แล้ว',
        backgroundColor: const Color(0xFF047857),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'อัปเดตไม่สำเร็จ',
        'กรุณาลองใหม่อีกครั้ง',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }
}
