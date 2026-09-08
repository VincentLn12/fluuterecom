import 'package:flutter/material.dart';

class ManageMerchantContentsPage extends StatelessWidget {
  const ManageMerchantContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการเนื้อหาร้านค้า'),
      ),
      body: const Center(
        child: Text('หน้าจัดการเนื้อหาของร้าน'),
      ),
    );
  }
}
