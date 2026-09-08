import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าแรก'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('Banner กาญจนบุรี Platform'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ร้านค้าแนะนำ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('รายการร้านค้าแนะนำ...'),
            const SizedBox(height: 20),
            const Text(
              'สินค้าแนะนำ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('รายการสินค้าแนะนำ...'),
            const SizedBox(height: 20),
            const Text(
              'เนื้อหา / ข่าวสารล่าสุด',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('รายการข่าวสารล่าสุด...'),
          ],
        ),
      ),
    );
  }
}
