import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/payment_controller.dart';
import '../widgets/payment/payment_bottom_bar.dart';
import '../widgets/payment/payment_method_options.dart';
import '../widgets/payment/payment_order_summary_card.dart';
import '../widgets/payment/payment_slip_form.dart';
import '../widgets/payment/payment_stripe_form.dart';

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
            const PaymentOrderSummaryCard(),

            const SizedBox(height: 18),

            // 2. Section Header: Select Payment Method
            _buildSectionHeader(
              'เลือกช่องทางการชำระเงิน',
              Icons.account_balance_wallet_rounded,
            ),

            const SizedBox(height: 12),

            // 3. Payment Method Choice Cards (Stripe vs PromptPay/Slip)
            const PaymentMethodOptions(),

            const SizedBox(height: 18),

            // 4. Active Method Dynamic Form View
            Obx(() {
              if (controller.selectedMethod.value == 'stripe') {
                return const PaymentStripeForm();
              } else {
                return const PaymentSlipForm();
              }
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const PaymentBottomBar(),
    );
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
}
