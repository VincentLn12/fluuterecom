import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../shops/models/product_model.dart';
import '../models/cart_item_model.dart';
import '../repositories/cart_repository.dart';

class CartController extends GetxController {
  final CartRepository _repository = CartRepository();
  final cartItems = <CartItemModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
    // Re-fetch cart whenever auth session state changes
    try {
      final authService = Get.find<AuthService>();
      ever(authService.isLoggedIn, (_) => fetchCart());
    } catch (e) {
      debugPrint('AuthService not found yet for CartController listener: $e');
    }
  }

  /// Fetch cart from backend DB
  Future<void> fetchCart() async {
    try {
      final authService = Get.find<AuthService>();
      if (!authService.isLoggedIn.value) {
        cartItems.clear();
        return;
      }

      isLoading.value = true;
      final cartData = await _repository.fetchCart();
      if (cartData != null && cartData.containsKey('items')) {
        final itemsList = cartData['items'] as List? ?? [];
        final parsedItems = itemsList
            .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
        cartItems.assignAll(parsedItems);
      }
    } catch (e) {
      debugPrint('Error loading backend cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  int get totalItemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get selectedItemCount => cartItems
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => cartItems
      .where((item) => item.isSelected)
      .fold(0.0, (sum, item) => sum + item.subtotal);

  bool get isAllSelected =>
      cartItems.isNotEmpty && cartItems.every((item) => item.isSelected);

  bool isShopAllSelected(String shopId) {
    final shopItems = cartItems
        .where((item) => item.effectiveShopId == shopId)
        .toList();
    return shopItems.isNotEmpty && shopItems.every((item) => item.isSelected);
  }

  Map<String, List<CartItemModel>> get groupedByShop {
    final map = <String, List<CartItemModel>>{};
    for (final item in cartItems) {
      final key = item.effectiveShopId;
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(item);
    }
    return map;
  }

  Future<void> addToCart(
    ProductModel product, {
    int quantity = 1,
    String? shopName,
  }) async {
    final authService = Get.find<AuthService>();
    if (!authService.isLoggedIn.value) {
      Get.snackbar(
        'กรุณาเข้าสู่ระบบ',
        'กรุณาเข้าสู่ระบบก่อนเพิ่มสินค้าลงในตะกร้าสินค้า',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () => Get.toNamed(AppRoutes.login),
          child: const Text(
            'เข้าสู่ระบบ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    try {
      final success = await _repository.addToCart(product.id, quantity);
      if (success) {
        await fetchCart();
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }

    Get.snackbar(
      'เพิ่มลงตะกร้าเรียบร้อย',
      'เพิ่ม "${product.name}" จำนวน $quantity ชิ้น ลงในตะกร้าสินค้าแล้ว',
      backgroundColor: const Color(0xFF2B1F17),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.shopping_bag_rounded, color: Color(0xFFD96C2C)),
    );
  }

  Future<void> removeFromCart(String id) async {
    cartItems.removeWhere((item) => item.id == id);
    try {
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn.value) {
        await _repository.deleteCartItem(id);
      }
    } catch (e) {
      debugPrint('Error removing cart item: $e');
    }
  }

  Future<void> removeSelectedItems() async {
    final selectedIds = cartItems
        .where((item) => item.isSelected)
        .map((e) => e.id)
        .toList();
    cartItems.removeWhere((item) => item.isSelected);

    try {
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn.value) {
        for (final id in selectedIds) {
          await _repository.deleteCartItem(id);
        }
      }
    } catch (e) {
      debugPrint('Error removing selected cart items: $e');
    }
  }

  Future<void> incrementQuantity(String id) async {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final item = cartItems[index];
      final newQty = item.quantity + 1;
      cartItems[index] = item.copyWith(quantity: newQty);

      try {
        final authService = Get.find<AuthService>();
        if (authService.isLoggedIn.value) {
          await _repository.updateCartItemQuantity(id, newQty);
        }
      } catch (e) {
        debugPrint('Error incrementing cart quantity: $e');
      }
    }
  }

  Future<void> decrementQuantity(String id) async {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final item = cartItems[index];
      if (item.quantity > 1) {
        final newQty = item.quantity - 1;
        cartItems[index] = item.copyWith(quantity: newQty);

        try {
          final authService = Get.find<AuthService>();
          if (authService.isLoggedIn.value) {
            await _repository.updateCartItemQuantity(id, newQty);
          }
        } catch (e) {
          debugPrint('Error decrementing cart quantity: $e');
        }
      } else {
        await removeFromCart(id);
      }
    }
  }

  void toggleSelect(String id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final item = cartItems[index];
      cartItems[index] = item.copyWith(isSelected: !item.isSelected);
    }
  }

  void toggleSelectShop(String shopId, bool select) {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].effectiveShopId == shopId) {
        cartItems[i] = cartItems[i].copyWith(isSelected: select);
      }
    }
  }

  void toggleSelectAll(bool select) {
    for (int i = 0; i < cartItems.length; i++) {
      cartItems[i] = cartItems[i].copyWith(isSelected: select);
    }
  }

  void clearCart() {
    cartItems.clear();
  }
}
