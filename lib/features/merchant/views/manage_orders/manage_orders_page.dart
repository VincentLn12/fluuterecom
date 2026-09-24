import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/views/manage_orders/widgets/manage_order_card.dart';
import 'package:projecte/features/merchant/views/manage_orders/widgets/manage_orders_filter_tabs.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'package:projecte/features/merchant/controllers/manage_orders_controller.dart';

class ManageOrdersPage extends GetView<ManageOrdersController> {
  const ManageOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.assignment_rounded,
                color: Color(0xFF047857),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'จัดการคำสั่งซื้อ',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Merchant Order Management',
                    style: GoogleFonts.krub(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Obx(() {
            return Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: IconButton(
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF047857),
                        ),
                      )
                    : const Icon(
                        Icons.refresh_rounded,
                        color: Color(0xFF047857),
                        size: 22,
                      ),
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.loadOrders(),
                tooltip: 'รีเฟรชข้อมูล',
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs Bar
          ManageOrdersFilterTabs(controller: controller),

          // Orders List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget(
                  message: 'กำลังโหลดรายการคำสั่งซื้อ...',
                );
              }

              final list = controller.filteredOrders;

              if (list.isEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            controller.myShop.value == null
                                ? Icons.storefront_outlined
                                : Icons.assignment_outlined,
                            size: 54,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.myShop.value == null
                              ? 'ยังไม่ได้ลงทะเบียนร้านค้า'
                              : 'ไม่พบรายการคำสั่งซื้อในหมวดนี้',
                          style: GoogleFonts.krub(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            controller.myShop.value == null
                                ? 'กรุณากรอกข้อมูลลงทะเบียนร้านค้าเพื่อเปิดใช้งานและรับออเดอร์'
                                : 'คำสั่งซื้อที่ผู้ใช้ชำระเงินเข้ามาจะแสดงผลเรียงตามเวลาในหน้านี้',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.krub(
                              fontSize: 13,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                        if (controller.myShop.value == null) ...[
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () =>
                                Get.toNamed(AppRoutes.registerShop),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.edit_document, size: 18),
                            label: Text(
                              'ลงทะเบียนร้านค้าใหม่',
                              style: GoogleFonts.krub(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadOrders,
                color: const Color(0xFF047857),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final order = list[index];
                    return ManageOrderCard(
                      controller: controller,
                      order: order,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
