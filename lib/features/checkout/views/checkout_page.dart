import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/checkout_controller.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ยืนยันการสั่งซื้อสินค้า',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Receiver & Address Info
            _buildSectionCard(
              title: 'ข้อมูลผู้รับ & ที่อยู่จัดส่ง',
              icon: Icons.local_shipping_rounded,
              iconColor: const Color(0xFFD96C2C),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (controller.savedAddresses.isEmpty)
                      return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'เลือกจากที่อยู่ที่บันทึกไว้:',
                          style: GoogleFonts.krub(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: controller.savedAddresses.map((addr) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ActionChip(
                                  backgroundColor: const Color(
                                    0xFF1F5F58,
                                  ).withValues(alpha: 0.1),
                                  label: Text(
                                    '${addr.recipientName} (${addr.district ?? "กาญจนบุรี"})',
                                    style: GoogleFonts.krub(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1F5F58),
                                    ),
                                  ),
                                  onPressed: () =>
                                      controller.applyAddress(addr),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    );
                  }),
                  AppTextField(
                    controller: controller.receiverNameController,
                    labelText: 'ชื่อ-นามสกุล ผู้รับสินค้า',
                    hintText: 'กรอกชื่อผู้รับ',
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFFD96C2C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: controller.receiverPhoneController,
                    labelText: 'เบอร์โทรศัพท์ติดต่อ',
                    hintText: '08X-XXX-XXXX',
                    prefixIcon: const Icon(
                      Icons.phone_iphone_rounded,
                      color: Color(0xFFD96C2C),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: controller.addressLineController,
                    labelText: 'ที่อยู่ (บ้านเลขที่ / ถนน / ซอย)',
                    hintText: '123/45 ถนนแสงชูโต',
                    prefixIcon: const Icon(
                      Icons.home_outlined,
                      color: Color(0xFFD96C2C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: controller.subDistrictController,
                          labelText: 'ตำบล / แขวง',
                          hintText: 'บ้านเหนือ',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          controller: controller.districtController,
                          labelText: 'อำเภอ / เขต',
                          hintText: 'เมืองกาญจนบุรี',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: controller.provinceController,
                          labelText: 'จังหวัด',
                          hintText: 'กาญจนบุรี',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          controller: controller.postalCodeController,
                          labelText: 'รหัสไปรษณีย์',
                          hintText: '71000',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Section 2: Order Items Breakdown
            _buildSectionCard(
              title: 'รายการสินค้าที่จะสั่งซื้อ',
              icon: Icons.shopping_bag_rounded,
              iconColor: const Color(0xFF1F5F58),
              child: Obx(() {
                final selectedItems = controller.cartController.cartItems
                    .where((item) => item.isSelected)
                    .toList();

                if (selectedItems.isEmpty) {
                  return Text(
                    'ไม่มีสินค้าที่เลือกในตะกร้า',
                    style: GoogleFonts.krub(color: Colors.red),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedItems.length,
                  separatorBuilder: (context, i) =>
                      const Divider(height: 16, color: Color(0xFFF0E6DC)),
                  itemBuilder: (context, i) {
                    final item = selectedItems[i];
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 50,
                            height: 50,
                            color: const Color(0xFFF7F0E6),
                            child:
                                item.product.imageUrl != null &&
                                    item.product.imageUrl!.isNotEmpty
                                ? Image.network(
                                    item.product.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.shopping_bag_outlined,
                                              color: Colors.grey,
                                            ),
                                  )
                                : const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.krub(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2B1F17),
                                ),
                              ),
                              Text(
                                '${item.effectiveShopName} • x${item.quantity}',
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '฿${item.subtotal.toStringAsFixed(2)}',
                          style: GoogleFonts.krub(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD96C2C),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 16),

            // Section 3: Shipping Method Selection
            _buildSectionCard(
              title: 'รูปแบบการจัดส่ง',
              icon: Icons.fire_truck_rounded,
              iconColor: const Color(0xFFC8952F),
              child: Obx(
                () => Column(
                  children: [
                    _buildShippingOption(
                      title: 'จัดส่งพัสดุแบบธรรมดา (Standard Delivery)',
                      subtitle: 'ระยะเวลาจัดส่ง 2-3 วันทำการ',
                      fee: 40.0,
                      methodKey: 'Standard Delivery',
                    ),
                    const SizedBox(height: 10),
                    _buildShippingOption(
                      title: 'จัดส่งแบบด่วนพิเศษ (Express Delivery)',
                      subtitle: 'ระยะเวลาจัดส่ง 1-2 วันทำการ',
                      fee: 60.0,
                      methodKey: 'Express Delivery',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section 4: Price Summary Breakdown
            _buildSectionCard(
              title: 'สรุปยอดชำระเงิน',
              icon: Icons.receipt_long_rounded,
              iconColor: const Color(0xFF2B1F17),
              child: Obx(
                () => Column(
                  children: [
                    _buildPriceRow(
                      'ยอดรวมสินค้า',
                      '฿${controller.subtotal.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 8),
                    _buildPriceRow(
                      'ค่าจัดส่ง',
                      '฿${controller.shippingFee.value.toStringAsFixed(2)}',
                    ),
                    const Divider(height: 20, color: Color(0xFFEADCCF)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ยอดสุทธิต้องชำระ',
                          style: GoogleFonts.krub(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2B1F17),
                          ),
                        ),
                        Text(
                          '฿${controller.totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.krub(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD96C2C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // Bottom Sticky CTA Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF332820).withValues(alpha: 0.10),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ยอดชำระสุทธิ',
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Obx(
                      () => Text(
                        '฿${controller.totalAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.krub(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFD96C2C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(
                  () => AppButton(
                    text: 'สั่งซื้อสินค้า',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.submitCheckout,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF332820).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B1F17),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFEADCCF)),
          child,
        ],
      ),
    );
  }

  Widget _buildShippingOption({
    required String title,
    required String subtitle,
    required double fee,
    required String methodKey,
  }) {
    final isSelected = controller.selectedShippingMethod.value == methodKey;

    return InkWell(
      onTap: () => controller.setShippingOption(methodKey, fee),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD96C2C).withValues(alpha: 0.08)
              : const Color(0xFFF7F0E6).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD96C2C)
                : const Color(0xFFEADCCF),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFD96C2C) : Colors.grey,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B1F17),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '฿${fee.toStringAsFixed(0)}',
              style: GoogleFonts.krub(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD96C2C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.krub(fontSize: 14, color: Colors.grey[700]),
        ),
        Text(
          amount,
          style: GoogleFonts.krub(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2B1F17),
          ),
        ),
      ],
    );
  }
}
