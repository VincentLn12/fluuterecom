import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตะกร้าสินค้า'),
      ),
      body: const Center(
        child: Text('ตะกร้าสินค้าว่างเปล่า'),
      ),
    );
  }
}
