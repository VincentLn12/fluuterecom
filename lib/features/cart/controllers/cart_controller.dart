import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shops/models/product_model.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  final cartItems = <CartItemModel>[].obs;

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
    final shopItems =
        cartItems.where((item) => item.effectiveShopId == shopId).toList();
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

  void addToCart(ProductModel product, {int quantity = 1, String? shopName}) {
    final existingIndex =
        cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      final existing = cartItems[existingIndex];
      final newQty = existing.quantity + quantity;
      cartItems[existingIndex] = existing.copyWith(
        quantity: newQty,
        isSelected: true,
      );
    } else {
      cartItems.add(
        CartItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          product: product,
          shopName: shopName,
          quantity: quantity,
          isSelected: true,
        ),
      );
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

  void removeFromCart(String id) {
    cartItems.removeWhere((item) => item.id == id);
  }

  void removeSelectedItems() {
    cartItems.removeWhere((item) => item.isSelected);
  }

  void incrementQuantity(String id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final item = cartItems[index];
      cartItems[index] = item.copyWith(quantity: item.quantity + 1);
    }
  }

  void decrementQuantity(String id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final item = cartItems[index];
      if (item.quantity > 1) {
        cartItems[index] = item.copyWith(quantity: item.quantity - 1);
      } else {
        removeFromCart(id);
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
