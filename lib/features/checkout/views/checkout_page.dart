import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ชำระเงิน / Checkout'),
      ),
      body: const Center(
        child: Text('หน้าชำระเงิน'),
      ),
    );
  }
}
