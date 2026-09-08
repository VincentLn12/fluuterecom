import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ชำระเงินสำเร็จ'),
      ),
      body: const Center(
        child: Text('ชำระเงินสำเร็จเรียบร้อย'),
      ),
    );
  }
}
