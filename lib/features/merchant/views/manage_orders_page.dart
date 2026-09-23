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
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      height: 56,
      child: Obx(() {
        final currentStatus = controller.selectedStatus.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                    fontSize: 13,
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF047857),
                backgroundColor: const Color(0xFFF1F5F9),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF047857)
                      : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
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
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFF059669),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(order.orderStatus),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Customer Info Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.person_rounded,
                  size: 20,
                  color: Color(0xFF047857),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'ผู้รับ: ${order.receiverName ?? 'ลูกค้าทั่วไป'}',
                              style: GoogleFonts.krub(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (order.receiverPhone != null &&
                              order.receiverPhone!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.phone_rounded,
                                    size: 10,
                                    color: Color(0xFF0284C7),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    order.receiverPhone!,
                                    style: GoogleFonts.krub(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0369A1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (order.shippingAddress != null &&
                          order.shippingAddress!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 13,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                order.shippingAddress!,
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Items List Header
          Text(
            'รายการสินค้าในออเดอร์',
            style: GoogleFonts.krub(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),

          // Items List
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.shopping_bag_rounded,
                            size: 20,
                            color: Color(0xFF94A3B8),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: GoogleFonts.krub(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'จำนวน: ${item.quantity} ชิ้น',
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '฿${item.totalPrice.toStringAsFixed(0)}',
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Total & Shipment Status Info Footer
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Shipping Method Badge
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        order.shippingMethod?.toLowerCase() == 'pickup'
                            ? Icons.store_rounded
                            : Icons.local_shipping_rounded,
                        size: 14,
                        color: const Color(0xFF0284C7),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          order.shippingMethod?.toLowerCase() == 'pickup'
                              ? 'รับที่ร้านค้า (Pickup)'
                              : 'จัดส่งทางพัสดุ (Delivery)',
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0369A1),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Total Amount
              Row(
                children: [
                  Text(
                    'ยอดรวม: ',
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
            ],
          ),

          if (order.carrierName != null && order.trackingNumber != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_rounded,
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

          const SizedBox(height: 14),
          // Action Button or Unpaid Warning Banner
          if (order.orderStatus.trim().toLowerCase() == 'pending') ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        controller.changeFulfillmentStatus(order, 'Cancelled'),
                    child: Text(
                      'ยกเลิกออเดอร์',
                      style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.changeFulfillmentStatus(order, 'Confirmed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF047857),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'ยืนยันออเดอร์',
                      style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (order.orderStatus.trim().toLowerCase() == 'confirmed') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    controller.changeFulfillmentStatus(order, 'Processing'),
                icon: const Icon(Icons.inventory_2_rounded),
                label: Text(
                  'เริ่มเตรียมจัดส่ง',
                  style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ] else if (order.paymentStatus.trim().toLowerCase() == 'paid' &&
              order.shippingMethod?.toLowerCase() != 'pickup' &&
              order.orderStatus.trim().toLowerCase() == 'processing') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showShipmentBottomSheet(context, order),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF047857),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.edit_road_rounded, size: 18),
                label: Text(
                  'บันทึกการจัดส่งและเลขพัสดุ',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ] else if (order.paymentStatus.trim().toLowerCase() == 'paid' &&
              order.shippingMethod?.toLowerCase() == 'pickup' &&
              order.orderStatus.trim().toLowerCase() != 'shipped' &&
              order.orderStatus.trim().toLowerCase() != 'completed' &&
              order.orderStatus.trim().toLowerCase() != 'cancelled') ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: Color(0xFF047857),
                  ),
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
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_rounded,
                    size: 18,
                    color: Color(0xFFD97706),
                  ),
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
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = const Color(0xFFF1F5F9);
    Color text = const Color(0xFF475569);
    String label = status;
    IconData icon = Icons.info_outline_rounded;

    switch (status.toLowerCase()) {
      case 'pending':
        bg = const Color(0xFFFFFBEB);
        text = const Color(0xFFD97706);
        label = 'รอยืนยันออเดอร์';
        icon = Icons.access_time_filled_rounded;
        break;
      case 'paid':
        bg = const Color(0xFFEFF6FF);
        text = const Color(0xFF0284C7);
        label = 'ชำระแล้ว';
        icon = Icons.verified_rounded;
        break;
      case 'processing':
        bg = const Color(0xFFF5F3FF);
        text = const Color(0xFF7C3AED);
        label = 'เตรียมจัดส่ง';
        icon = Icons.inventory_2_rounded;
        break;
      case 'shipped':
        bg = const Color(0xFFEEF2FF);
        text = const Color(0xFF4F46E5);
        label = 'จัดส่งแล้ว';
        icon = Icons.local_shipping_rounded;
        break;
      case 'completed':
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF059669);
        label = 'สำเร็จแล้ว';
        icon = Icons.check_circle_rounded;
        break;
      case 'cancelled':
        bg = const Color(0xFFFFF1F2);
        text = const Color(0xFFE11D48);
        label = 'ยกเลิกแล้ว';
        icon = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: text),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: text,
            ),
          ),
        ],
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BottomSheet Handle bar
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        color: Color(0xFF047857),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
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
                          Text(
                            'ออเดอร์ #${order.orderNumber ?? order.id}',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: carrierController,
                  style: GoogleFonts.krub(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'บริษัทขนส่ง *',
                    hintText: 'เช่น ไปรษณีย์ไทย, KERRY, Flash Express, J&T',
                    labelStyle: GoogleFonts.krub(
                      color: const Color(0xFF64748B),
                    ),
                    prefixIcon: const Icon(
                      Icons.business_rounded,
                      color: Color(0xFF047857),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF047857),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: trackingController,
                  style: GoogleFonts.krub(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'เลขติดตามพัสดุ (Tracking Number) *',
                    hintText: 'เช่น TH123456789TH',
                    labelStyle: GoogleFonts.krub(
                      color: const Color(0xFF64748B),
                    ),
                    prefixIcon: const Icon(
                      Icons.pin_rounded,
                      color: Color(0xFF047857),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF047857),
                        width: 1.5,
                      ),
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
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.check_circle_rounded),
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
