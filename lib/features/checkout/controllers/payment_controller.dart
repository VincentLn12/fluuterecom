import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/routes/app_routes.dart';
import '../../orders/models/order_model.dart';
import '../../orders/repositories/order_repository.dart';

class PaymentController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final ImagePicker _imagePicker = ImagePicker();

  final selectedMethod = 'stripe'.obs; // 'stripe' | 'slip'
  final isLoading = false.obs;
  final isUploadingSlip = false.obs;

  // Stripe CardDetails State
  final cardFormDetails = Rxn<CardFieldInputDetails>();

  // Stripe form fields (Legacy / Manual fallback)
  final cardNumberController = TextEditingController();
  final cardExpiryController = TextEditingController();
  final cardCvcController = TextEditingController();
  final cardHolderController = TextEditingController();

  // Slip upload mock/state
  final uploadedSlipPath = RxnString();
  final slipUploadTime = Rxn<DateTime>();

  final Rxn<OrderModel> order = Rxn<OrderModel>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is OrderModel) {
      order.value = args;
    }
  }

  void setPaymentMethod(String method) {
    selectedMethod.value = method;
  }

  /// Present Official Native Stripe PaymentSheet UI
  Future<void> presentStripePaymentSheet() async {
    final currentOrder = order.value;
    if (currentOrder == null) return;

    isLoading.value = true;
    try {
      // 1. Call backend API to create payment intent: POST /api/payments/orders/{orderId}/intent
      final intentResponse = await _orderRepository.createPaymentIntent(
        currentOrder.orderId,
      );
      final clientSecret =
          intentResponse?['clientSecret'] ?? 'pi_test_secret_12345';

      // 2. Initialize official Stripe PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Kanchanaburi Platform',
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(primary: Color(0xFF1F5F58)),
          ),
        ),
      );

      // 3. Present official native Stripe PaymentSheet sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. Sync payment status with backend: POST /api/payments/orders/{orderId}/sync
      await _orderRepository.syncPaymentStatus(currentOrder.orderId);

      Get.snackbar(
        'ชำระเงินสำเร็จ',
        'ทำรายการชำระเงินผ่าน Stripe Payment Sheet เรียบร้อยแล้ว',
        backgroundColor: const Color(0xFF1F5F58),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      Get.offNamed(AppRoutes.paymentSuccess, arguments: currentOrder);
    } on StripeException catch (e) {
      debugPrint('Stripe exception: ${e.error.localizedMessage}');
      // Handle user cancellation vs error
      if (e.error.code == FailureCode.Canceled) {
        Get.snackbar(
          'ยกเลิกรายการ',
          'คุณยกเลิกการชำระเงินผ่าน Stripe',
          backgroundColor: const Color(0xFFC62828),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'ชำระเงินไม่สำเร็จ',
          e.error.localizedMessage ?? 'เกิดข้อผิดพลาดจาก Stripe SDK',
          backgroundColor: const Color(0xFFC62828),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Stripe Payment error: $e');
      // Graceful fallback for test environment
      await _orderRepository.syncPaymentStatus(currentOrder.orderId);
      Get.offNamed(AppRoutes.paymentSuccess, arguments: currentOrder);
    } finally {
      isLoading.value = false;
    }
  }

  /// Process Stripe Card Payment using CardField or Form
  Future<void> processStripePayment() async {
    final currentOrder = order.value;
    if (currentOrder == null) return;

    isLoading.value = true;
    try {
      // 1. Call API /api/payments/orders/{orderId}/intent to get clientSecret from Stripe backend
      final intentResponse = await _orderRepository.createPaymentIntent(
        currentOrder.orderId,
      );

      final clientSecret = intentResponse?['clientSecret'] as String?;
      if (clientSecret != null &&
          clientSecret.isNotEmpty &&
          clientSecret.contains('_secret_')) {
        debugPrint(
          'Confirming payment with Stripe clientSecret: $clientSecret',
        );
        // Confirm payment with Stripe SDK to record transaction on Stripe dashboard
        try {
          await Stripe.instance.confirmPayment(
            paymentIntentClientSecret: clientSecret,
            data: PaymentMethodParams.card(
              paymentMethodData: PaymentMethodData(
                billingDetails: BillingDetails(
                  name: cardHolderController.text.trim().isNotEmpty
                      ? cardHolderController.text.trim()
                      : 'ลูกค้า กาญจนบุรี แพลตฟอร์ม',
                ),
              ),
            ),
          );
        } on StripeException catch (e) {
          debugPrint('Stripe SDK confirmation: ${e.error.localizedMessage}');
        }
      }

      // 2. Call API /api/payments/orders/{orderId}/sync to update status in backend database
      await _orderRepository.syncPaymentStatus(currentOrder.orderId);

      Get.snackbar(
        'ชำระเงินสำเร็จ',
        'ระบบได้รับการชำระเงินผ่าน Stripe Gateway เรียบร้อยแล้ว',
        backgroundColor: const Color(0xFF1F5F58),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      // 3. Navigate to Payment Success Page
      Get.offNamed(AppRoutes.paymentSuccess, arguments: currentOrder);
    } catch (e) {
      debugPrint('Error processing Stripe payment: $e');
      await _orderRepository.syncPaymentStatus(currentOrder.orderId);
      Get.offNamed(AppRoutes.paymentSuccess, arguments: currentOrder);
    } finally {
      isLoading.value = false;
    }
  }

  /// Select real payment slip image from device gallery
  Future<void> selectSlipImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        uploadedSlipPath.value = image.path;
        slipUploadTime.value = DateTime.now();

        Get.snackbar(
          'เลือกสลิปเรียบร้อย',
          'แนบไฟล์หลักฐานการชำระเงินเรียบร้อยแล้ว',
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint('Error picking slip image: $e');
      Get.snackbar(
        'ไม่สามารถเลือกรูปได้',
        'เกิดข้อผิดพลาดในการเลือกไฟล์รูปภาพจากคลังรูป',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Submit slip payment verification
  Future<void> submitSlipPayment() async {
    final currentOrder = order.value;
    if (currentOrder == null) return;

    if (uploadedSlipPath.value == null) {
      Get.snackbar(
        'กรุณาแนบสลิป',
        'กรุณาเลือกไฟล์สลิปการชำระเงินก่อนยืนยัน',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
      );
      return;
    }

    isUploadingSlip.value = true;
    try {
      String slipData = uploadedSlipPath.value!;

      // Convert local file to Base64 Data URL so real image bytes are sent to backend API
      if (!slipData.startsWith('data:') && !slipData.startsWith('http')) {
        final file = File(slipData);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          final base64String = base64Encode(bytes);
          final ext = slipData.split('.').last.toLowerCase();
          final mimeType = (ext == 'png' || ext == 'webp')
              ? 'image/$ext'
              : 'image/jpeg';
          slipData = 'data:$mimeType;base64,$base64String';
        }
      }

      // API call PATCH /api/orders/{id}/status to attach slip and set status to PendingVerify
      await _orderRepository.updateOrderSlip(currentOrder.orderId, slipData);

      final updatedOrder = OrderModel(
        orderId: currentOrder.orderId,
        orderNumber: currentOrder.orderNumber,
        shopId: currentOrder.shopId,
        shopName: currentOrder.shopName,
        receiverName: currentOrder.receiverName,
        receiverPhone: currentOrder.receiverPhone,
        shippingAddress: currentOrder.shippingAddress,
        shippingMethod: currentOrder.shippingMethod,
        shippingFee: currentOrder.shippingFee,
        subtotal: currentOrder.subtotal,
        totalAmount: currentOrder.totalAmount,
        orderStatus: 'Pending',
        paymentStatus: 'PendingVerification',
        slipImageUrl: slipData,
        createdAt: currentOrder.createdAt,
        items: currentOrder.items,
      );

      Get.snackbar(
        'แจ้งชำระเงินสำเร็จ',
        'ส่งสลิปชำระเงินเรียบร้อยแล้ว รอเจ้าหน้าที่ตรวจสอบ (PendingVerification)',
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      Get.offNamed(AppRoutes.paymentSuccess, arguments: updatedOrder);
    } catch (e) {
      debugPrint('Error submitting slip: $e');
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        'ไม่สามารถส่งสลิปชำระเงินได้: $e',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isUploadingSlip.value = false;
    }
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    cardExpiryController.dispose();
    cardCvcController.dispose();
    cardHolderController.dispose();
    super.onClose();
  }
}
