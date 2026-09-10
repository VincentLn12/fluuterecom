import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/payment_controller.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PaymentController>()) {
      Get.put(PaymentController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'เลือกวิธีชำระเงิน',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Order Summary Card
            _buildOrderSummaryCard(),

            const SizedBox(height: 18),

            // 2. Section Header: Select Payment Method
            _buildSectionHeader(
              'เลือกช่องทางการชำระเงิน',
              Icons.account_balance_wallet_rounded,
            ),

            const SizedBox(height: 12),

            // 3. Payment Method Choice Cards (Stripe vs PromptPay/Slip)
            _buildPaymentMethodOptions(),

            const SizedBox(height: 18),

            // 4. Active Method Dynamic Form View
            Obx(() {
              if (controller.selectedMethod.value == 'stripe') {
                return _buildStripePaymentForm();
              } else {
                return _buildSlipPaymentForm(context);
              }
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Obx(() {
      final currentOrder = controller.order.value;
      final total = currentOrder?.totalAmount ?? 0.0;
      final orderNo =
          currentOrder?.orderNumber ??
          'ORD-${DateTime.now().millisecondsSinceEpoch}';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F2),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE8D9C9), width: 1.8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 18,
                        color: Color(0xFFD96C2C),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'หมายเลขคำสั่งซื้อ',
                      style: GoogleFonts.krub(
                        fontSize: 13.5,
                        color: const Color(0xFF786B62),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Text(
                    '#$orderNo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF332820),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE8D9C9)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ยอดสุทธิต้องชำระ',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF332820),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.security_rounded,
                          size: 14,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ปลอดภัย 100% (SSL Encrypted)',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            color: const Color(0xFF059669),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '฿${total.toStringAsFixed(2)}',
                  style: GoogleFonts.krub(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFD96C2C), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.krub(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF332820),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOptions() {
    return Obx(() {
      final selected = controller.selectedMethod.value;

      return Column(
        children: [
          // Option 1: Stripe (Card / PromptPay / Apple Pay)
          _buildMethodCard(
            id: 'stripe',
            isSelected: selected == 'stripe',
            title: 'บัตรเครดิต / เดบิต (Stripe Gateway)',
            subtitle: 'รองรับ Visa, MasterCard, JCB, UnionPay ชำระเงินทันที',
            icon: Icons.credit_card_rounded,
            accentColor: const Color(0xFF1F5F58),
            badges: ['Visa', 'MasterCard', 'JCB', 'Stripe'],
            onTap: () => controller.setPaymentMethod('stripe'),
          ),

          const SizedBox(height: 12),

          // Option 2: PromptPay & Bank Transfer Slip
          _buildMethodCard(
            id: 'slip',
            isSelected: selected == 'slip',
            title: 'สแกน QR Code / โอนผ่านธนาคาร',
            subtitle: 'โอนผ่านแอปธนาคาร PromptPay ฟรีค่าธรรมเนียม พร้อมแนบสลิป',
            icon: Icons.qr_code_scanner_rounded,
            accentColor: const Color(0xFFD96C2C),
            badges: ['PromptPay', 'โอนเงิน', 'ฟรีค่าธรรมเนียม'],
            onTap: () => controller.setPaymentMethod('slip'),
          ),
        ],
      );
    });
  }

  Widget _buildMethodCard({
    required String id,
    required bool isSelected,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required List<String> badges,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0xFFE8D9C9),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio Indicator
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected ? accentColor : const Color(0xFF786B62),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Main Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 18, color: accentColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.krub(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF332820),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.krub(
                      fontSize: 12.5,
                      color: const Color(0xFF786B62),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: badges.map((badge) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accentColor.withValues(alpha: 0.1)
                              : const Color(0xFFE8D9C9).withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.krub(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? accentColor
                                : const Color(0xFF786B62),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// System 1: Stripe Credit Card Payment Form (Direct Form Entry)
  Widget _buildStripePaymentForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.credit_card_rounded,
                color: Color(0xFF1F5F58),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'กรอกข้อมูลบัตรเครดิต / เดบิต',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F5F58).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'SSL 256-bit',
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F5F58),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          const SizedBox(height: 16),

          Text(
            'หมายเลขบัตร, วันหมดอายุ และ CVC',
            style: GoogleFonts.krub(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF332820),
            ),
          ),
          const SizedBox(height: 8),

          // Official Stripe CardField Widget for Direct Typing
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: CardFormField(
              controller: CardFormEditController(),
              onCardChanged: (card) {
                controller.cardFormDetails.value = card;
              },
            ),
          ),

          const SizedBox(height: 16),

          AppTextField(
            controller: controller.cardHolderController,
            labelText: 'ชื่อบนหน้าบัตร (Cardholder Name)',
            hintText: 'เช่น SOMCHAI JAIDEE',
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF1F5F58),
            ),
          ),

          const SizedBox(height: 22),

          Obx(
            () => AppButton(
              text:
                  'ยืนยันชำระเงินด้วยบัตร • ฿${(controller.order.value?.totalAmount ?? 0.0).toStringAsFixed(2)}',
              color: const Color(0xFF1F5F58),
              icon: Icons.lock_rounded,
              isLoading: controller.isLoading.value,
              onPressed: controller.processStripePayment,
            ),
          ),
        ],
      ),
    );
  }

  /// System 2: PromptPay QR & Slip Upload Form
  Widget _buildSlipPaymentForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.qr_code_2_rounded,
                color: Color(0xFFD96C2C),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'โอนเงินผ่าน PromptPay หรือ ธนาคาร',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF332820),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // PromptPay QR Frame Showcase
          Container(
            width: 190,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF003865),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003865).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'PromptPay QR',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 110,
                        color: Color(0xFF332820),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'สแกนด้วยแอปธนาคาร',
                        style: GoogleFonts.krub(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF786B62),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bank Details Box with Copy Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8D9C9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ธนาคารกรุงไทย (KTB)',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF003865),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                          const ClipboardData(text: '7010982145'),
                        );
                        Get.snackbar(
                          'คัดลอกสำเร็จ',
                          'คัดลอกเลขที่บัญชี 701-0-98214-5 เรียบร้อยแล้ว',
                          backgroundColor: const Color(0xFF2B1F17),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                          borderRadius: 12,
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003865).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.copy_rounded,
                              size: 13,
                              color: Color(0xFF003865),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'คัดลอกเลขบัญชี',
                              style: GoogleFonts.krub(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF003865),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'เลขที่บัญชี: 701-0-98214-5',
                  style: GoogleFonts.krub(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF332820),
                  ),
                ),
                Text(
                  'ชื่อบัญชี: กาญจนบุรี แพลตฟอร์ม (KRU Boat API)',
                  style: GoogleFonts.krub(
                    fontSize: 12.5,
                    color: const Color(0xFF786B62),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          const SizedBox(height: 16),

          // Slip Upload Box
          Obx(() {
            final slip = controller.uploadedSlipPath.value;
            final uploadTime = controller.slipUploadTime.value;

            if (slip != null) {
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF059669),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: _buildSlipImageWidget(slip),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'แนบสลิปชำระเงินเรียบร้อยแล้ว',
                            style: GoogleFonts.krub(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF059669),
                            ),
                          ),
                          if (uploadTime != null)
                            Text(
                              'อัปโหลดเมื่อ: ${uploadTime.hour}:${uploadTime.minute.toString().padLeft(2, "0")} น.',
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                color: const Color(0xFF786B62),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        controller.uploadedSlipPath.value = null;
                      },
                    ),
                  ],
                ),
              );
            }

            return OutlinedButton.icon(
              onPressed: controller.selectSlipImage,
              icon: const Icon(Icons.cloud_upload_rounded, size: 22),
              label: Text(
                'คลิกเพื่อแนบสลิปชำระเงิน (Upload Slip)',
                style: GoogleFonts.krub(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFD96C2C),
                side: const BorderSide(color: Color(0xFFD96C2C), width: 1.8),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          Obx(
            () => AppButton(
              text: 'ยืนยันและส่งสลิปชำระเงิน',
              color: const Color(0xFFD96C2C),
              icon: Icons.check_circle_outline_rounded,
              isLoading: controller.isUploadingSlip.value,
              onPressed: controller.submitSlipPayment,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Obx(() {
      final currentOrder = controller.order.value;
      final total = currentOrder?.totalAmount ?? 0.0;
      final isStripe = controller.selectedMethod.value == 'stripe';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F2),
          border: const Border(
            top: BorderSide(color: Color(0xFFE8D9C9), width: 1.5),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ยอดชำระสุทธิ',
                    style: GoogleFonts.krub(
                      fontSize: 12.5,
                      color: const Color(0xFF786B62),
                    ),
                  ),
                  Text(
                    '฿${total.toStringAsFixed(2)}',
                    style: GoogleFonts.krub(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFD96C2C),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (isStripe) {
                        controller.processStripePayment();
                      } else {
                        controller.submitSlipPayment();
                      }
                    },
                    icon: Icon(
                      isStripe ? Icons.lock_rounded : Icons.send_rounded,
                      size: 18,
                    ),
                    label: Text(
                      isStripe ? 'ยืนยันชำระเงินด้วยบัตร' : 'ยืนยันส่งสลิป',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isStripe
                          ? const Color(0xFF1F5F58)
                          : const Color(0xFFD96C2C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSlipImageWidget(
    String slip, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (slip.startsWith('data:image')) {
      try {
        final base64Data = slip.split(',').last;
        final bytes = base64Decode(base64Data);
        return Image.memory(bytes, width: width, height: height, fit: fit);
      } catch (_) {}
    }
    if (slip.startsWith('http://') || slip.startsWith('https://')) {
      return Image.network(
        slip,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFF059669),
          child: const Icon(Icons.image_rounded, color: Colors.white, size: 28),
        ),
      );
    }
    final file = File(slip);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFF059669),
          child: const Icon(Icons.image_rounded, color: Colors.white, size: 28),
        ),
      );
    }
    return Container(
      color: const Color(0xFF059669),
      child: const Icon(Icons.image_rounded, color: Colors.white, size: 28),
    );
  }
}
