import 'dart:io';
import 'package:flutter/material.dart';
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
    // Register controller if not present
    if (!Get.isRegistered<PaymentController>()) {
      Get.put(PaymentController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'เลือกวิธีชำระเงิน',
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
          children: [
            // Order Summary Header Card
            Obx(() {
              final currentOrder = controller.order.value;
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF332820).withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'หมายเลขคำสั่งซื้อ:',
                          style: GoogleFonts.krub(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          currentOrder?.orderNumber ?? 'ORD-${DateTime.now().millisecondsSinceEpoch}',
                          style: GoogleFonts.krub(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F5F58),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: Color(0xFFEADCCF)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ยอดสุทธิต้องชำระ:',
                          style: GoogleFonts.krub(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2B1F17),
                          ),
                        ),
                        Text(
                          '฿${(currentOrder?.totalAmount ?? 0.0).toStringAsFixed(2)}',
                          style: GoogleFonts.krub(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD96C2C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Payment Method Selector Tabs (Stripe vs Slip Upload)
            Obx(() => Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEADCCF)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.setPaymentMethod('stripe'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedMethod.value == 'stripe'
                                  ? const Color(0xFF1F5F58)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.credit_card_rounded,
                                  size: 18,
                                  color: controller.selectedMethod.value == 'stripe'
                                      ? Colors.white
                                      : const Color(0xFF2B1F17),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Stripe (บัตรเดบิต/เครดิต)',
                                  style: GoogleFonts.krub(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: controller.selectedMethod.value == 'stripe'
                                        ? Colors.white
                                        : const Color(0xFF2B1F17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.setPaymentMethod('slip'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedMethod.value == 'slip'
                                  ? const Color(0xFFD96C2C)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_rounded,
                                  size: 18,
                                  color: controller.selectedMethod.value == 'slip'
                                      ? Colors.white
                                      : const Color(0xFF2B1F17),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'โอนเงิน & แนบสลิป',
                                  style: GoogleFonts.krub(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: controller.selectedMethod.value == 'slip'
                                        ? Colors.white
                                        : const Color(0xFF2B1F17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 20),

            // Tab View Content Body
            Obx(() {
              if (controller.selectedMethod.value == 'stripe') {
                return _buildStripePaymentForm();
              } else {
                return _buildSlipPaymentForm();
              }
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// System 1: Stripe Credit Card Payment Form
  Widget _buildStripePaymentForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF332820).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_rounded, color: Color(0xFF1F5F58), size: 20),
              const SizedBox(width: 8),
              Text(
                'ชำระเงินด้วย Stripe (Official SDK)',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B1F17),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F5F58).withValues(alpha: 0.1),
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
          const Divider(height: 24, color: Color(0xFFEADCCF)),

          // 1. Official Stripe Native PaymentSheet CTA Button
          Obx(() => AppButton(
                text: 'เปิด Stripe Payment Sheet (Official Native UI)',
                color: const Color(0xFF6772E5), // Official Stripe Blurple
                icon: Icons.shield_rounded,
                isLoading: controller.isLoading.value,
                onPressed: controller.presentStripePaymentSheet,
              )),

          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFFEADCCF))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'หรือ กรอกข้อมูลบัตรบนแอป (Stripe CardField Widget)',
                  style: GoogleFonts.krub(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
              const Expanded(child: Divider(color: Color(0xFFEADCCF))),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Official Stripe CardField Widget
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F0E6).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEADCCF)),
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
            hintText: 'SOMCHAI JAIDEE',
            prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF1F5F58)),
          ),

          const SizedBox(height: 24),

          Obx(() => AppButton(
                text: 'ยืนยันชำระเงินด้วยบัตร • ฿${(controller.order.value?.totalAmount ?? 0.0).toStringAsFixed(2)}',
                color: const Color(0xFF1F5F58),
                icon: Icons.credit_card_rounded,
                isLoading: controller.isLoading.value,
                onPressed: controller.processStripePayment,
              )),
        ],
      ),
    );
  }

  /// System 2: PromptPay QR & Slip Upload Form
  Widget _buildSlipPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF332820).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_2_rounded, color: Color(0xFFD96C2C), size: 22),
              const SizedBox(width: 8),
              Text(
                'โอนเงินผ่าน PromptPay หรือ ธนาคาร',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B1F17),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // PromptPay QR Frame Mockup
          Container(
            width: 180,
            height: 180,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF003865),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner_rounded, size: 90, color: Color(0xFF2B1F17)),
                  const SizedBox(height: 4),
                  Text(
                    'PromptPay QR',
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

          const SizedBox(height: 14),
          Text(
            'ธนาคารกรุงไทย (KRU Boat API)\nเลขที่บัญชี: 701-0-98214-5\nชื่อบัญชี: กาญจนบุรี แพลตฟอร์ม',
            textAlign: TextAlign.center,
            style: GoogleFonts.krub(
              fontSize: 13,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          const Divider(height: 24, color: Color(0xFFEADCCF)),

          // Slip Image Upload Selector Box
          Obx(() {
            final slip = controller.uploadedSlipPath.value;
            final uploadTime = controller.slipUploadTime.value;

            if (slip != null) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2E7D32)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 54,
                        height: 54,
                        child: slip.startsWith('http')
                            ? Image.network(slip, fit: BoxFit.cover)
                            : Image.file(File(slip), fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFF2E7D32),
                                  child: const Icon(Icons.image_rounded, color: Colors.white, size: 28),
                                );
                              }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'แนบสลิปชำระเงินเรียบร้อยแล้ว',
                            style: GoogleFonts.krub(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                          if (uploadTime != null)
                            Text(
                              'อัปโหลดเมื่อ: ${uploadTime.hour}:${uploadTime.minute.toString().padLeft(2, "0")} น.',
                              style: GoogleFonts.krub(fontSize: 12, color: Colors.grey[700]),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel_rounded, color: Colors.red),
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
                style: GoogleFonts.krub(fontSize: 15, fontWeight: FontWeight.bold),
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

          Obx(() => AppButton(
                text: 'ยืนยันและส่งสลิปชำระเงิน',
                color: const Color(0xFFD96C2C),
                icon: Icons.check_circle_outline_rounded,
                isLoading: controller.isUploadingSlip.value,
                onPressed: controller.submitSlipPayment,
              )),
        ],
      ),
    );
  }
}
