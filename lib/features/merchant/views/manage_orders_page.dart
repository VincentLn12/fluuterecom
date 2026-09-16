import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../orders/models/order_model.dart';
import '../controllers/manage_orders_controller.dart';

class ManageOrdersPage extends GetView<ManageOrdersController> {
  const ManageOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(
          'จัดการคำสั่งซื้อร้านค้า',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: Column(
        children: [
          // Filter Tabs
          _buildFilterTabs(),

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
                        Icon(
                          controller.myShop.value == null
                              ? Icons.storefront_outlined
                              : Icons.assignment_outlined,
                          size: 64,
                          color: const Color(0xFFCBD5E1),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          controller.myShop.value == null
                              ? 'ยังไม่ได้ลงทะเบียนร้านค้า'
                              : 'ไม่พบรายการคำสั่งซื้อในหมวดนี้',
                          style: GoogleFonts.krub(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.myShop.value == null
                              ? 'กรุณากรอกข้อมูลลงทะเบียนร้านค้าเพื่อเปิดใช้งานและรับออเดอร์'
                              : 'คำสั่งซื้อที่ผู้ใช้ชำระเงินเข้ามาจะแสดงผลในหน้านี้',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.krub(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        if (controller.myShop.value == null) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => Get.toNamed(AppRoutes.registerShop),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.edit_document, size: 18),
                            label: Text(
                              'ลงทะเบียนร้านค้าใหม่',
                              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
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
                    return _buildOrderCard(context, order);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white,
      height: 52,
      child: Obx(() {
        final currentStatus = controller.selectedStatus.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: controller.statusTabs.length,
          itemBuilder: (context, index) {
            final tab = controller.statusTabs[index];
            final isSelected = currentStatus == tab['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(
                  tab['label']!,
                  style: GoogleFonts.krub(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                    fontSize: 13,
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF047857),
                backgroundColor: const Color(0xFFF1F5F9),
                side: BorderSide.none,
                onSelected: (_) => controller.changeStatusTab(tab['value']!),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ออเดอร์ #${order.orderNumber ?? order.id}',
                  style: GoogleFonts.krub(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(order.orderStatus),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),

          // Customer Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ผู้รับ: ${order.receiverName ?? 'ลูกค้า'} (${order.receiverPhone ?? 'ไม่ระบุเบอร์โทร'})',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    if (order.shippingAddress != null &&
                        order.shippingAddress!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'ที่อยู่: ${order.shippingAddress}',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Items List
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.shopping_bag_outlined,
                            size: 20,
                            color: Color(0xFF64748B),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.productName,
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        color: const Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'x${item.quantity}',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '฿${item.totalPrice.toStringAsFixed(0)}',
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Total & Shipment Status Info
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ราคารวมทั้งหมด:',
                style: GoogleFonts.krub(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                '฿${order.totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.krub(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF047857),
                ),
              ),
            ],
          ),

          // Shipping Method Badge
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        order.shippingMethod?.toLowerCase() == 'pickup'
                            ? Icons.store_rounded
                            : Icons.local_shipping_outlined,
                        size: 14,
                        color: const Color(0xFF0284C7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.shippingMethod?.toLowerCase() == 'pickup'
                            ? 'รับที่ร้านค้า (Pickup)'
                            : 'จัดส่งทางพัสดุ (Delivery)',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (order.carrierName != null && order.trackingNumber != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    size: 18,
                    color: Color(0xFF047857),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ขนส่ง: ${order.carrierName} • เลขพัสดุ: ${order.trackingNumber}',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065F46),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          // Action Button or Unpaid Warning Banner (Matching Vue logic)
          if (order.paymentStatus == 'Paid' &&
              order.shippingMethod?.toLowerCase() != 'pickup' &&
              order.orderStatus != 'Shipped' &&
              order.orderStatus != 'Completed' &&
              order.orderStatus != 'Cancelled') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showShipmentBottomSheet(context, order),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF047857),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.edit_road_rounded, size: 18),
                label: Text(
                  'กรอกเลขพัสดุ / อัปเดตจัดส่ง',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ] else if (order.paymentStatus == 'Paid' &&
              order.shippingMethod?.toLowerCase() == 'pickup' &&
              order.orderStatus != 'Completed' &&
              order.orderStatus != 'Cancelled') ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 18, color: Color(0xFF047857)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ลูกค้าระบุรับสินค้าที่ร้าน (ชำระเงินแล้ว)',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065F46),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (order.paymentStatus != 'Paid') ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFFD97706)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.paymentStatus == 'PendingVerification'
                          ? 'ลูกค้าแนบสลิปชำระเงินแล้ว ระบบกำลังอยู่ระหว่างรอ Admin ตรวจสอบอนุมัติ'
                          : 'ลูกค้ายังไม่ได้ชำระเงินในระบบ กรุณารอการชำระเงินสำเร็จก่อนจัดส่งสินค้า',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (order.orderStatus == 'Shipped' || order.orderStatus == 'Completed') ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showShipmentBottomSheet(context, order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF047857),
                  side: const BorderSide(color: Color(0xFF047857)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: Text(
                  'แก้ไขเลขพัสดุ / ข้อมูลจัดส่ง',
                  style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = const Color(0xFFF1F5F9);
    Color text = const Color(0xFF475569);
    String label = status;

    switch (status.toLowerCase()) {
      case 'pending':
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFD97706);
        label = 'รอชำระ';
        break;
      case 'paid':
        bg = const Color(0xFFE0F2FE);
        text = const Color(0xFF0284C7);
        label = 'ชำระแล้ว';
        break;
      case 'processing':
        bg = const Color(0xFFF3E8FF);
        text = const Color(0xFF7C3AED);
        label = 'เตรียมจัดส่ง';
        break;
      case 'shipped':
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF059669);
        label = 'จัดส่งแล้ว';
        break;
      case 'completed':
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF15803D);
        label = 'สำเร็จแล้ว';
        break;
      case 'cancelled':
        bg = const Color(0xFFFFE4E6);
        text = const Color(0xFFE11D48);
        label = 'ยกเลิกแล้ว';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.krub(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }

  void _showShipmentBottomSheet(BuildContext context, OrderModel order) {
    final carrierController = TextEditingController(
      text: order.carrierName ?? 'ไปรษณีย์ไทย (EMS)',
    );
    final trackingController = TextEditingController(
      text: order.trackingNumber ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'บันทึกข้อมูลจัดส่งพัสดุ',
                  style: GoogleFonts.krub(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ออเดอร์ #${order.orderNumber ?? order.id}',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: carrierController,
                  style: GoogleFonts.krub(),
                  decoration: InputDecoration(
                    labelText: 'บริษัทขนส่ง *',
                    hintText: 'เช่น ไปรษณีย์ไทย, KERRY, Flash Express, J&T',
                    labelStyle: GoogleFonts.krub(),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: trackingController,
                  style: GoogleFonts.krub(),
                  decoration: InputDecoration(
                    labelText: 'เลขติดตามพัสดุ (Tracking Number) *',
                    hintText: 'เช่น TH123456789TH',
                    labelStyle: GoogleFonts.krub(),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.submitShipmentFulfillment(
                        order: order,
                        carrierName: carrierController.text,
                        trackingNumber: trackingController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF047857),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: Text(
                      'บันทึกและเปลี่ยนสถานะเป็น "จัดส่งแล้ว"',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
