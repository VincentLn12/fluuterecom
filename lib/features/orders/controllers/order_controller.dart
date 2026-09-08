import 'package:get/get.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _repository = OrderRepository();

  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      final list = await _repository.fetchMyOrders();
      orders.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }
}
