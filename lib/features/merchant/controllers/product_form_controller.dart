import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../shops/models/product_model.dart';
import '../repositories/merchant_repository.dart';

class ProductFormController extends GetxController {
  final MerchantRepository _repository = Get.find<MerchantRepository>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageUrlController = TextEditingController();

  final selectedCategoryId = RxnString();
  final status = 'Active'.obs;
  final categories = <Map<String, dynamic>>[].obs;

  final isLoading = true.obs;
  final isSaving = false.obs;

  ProductModel? editingProduct;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      editingProduct = args;
    }
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final cats = await _repository.fetchProductCategories();
      categories.value = cats;

      if (editingProduct != null) {
        final p = editingProduct!;
        nameController.text = p.name;
        priceController.text = p.price.toStringAsFixed(0);
        quantityController.text = p.quantity.toString();
        descriptionController.text = p.description ?? '';
        imageUrlController.text = p.imageUrl ?? '';
        selectedCategoryId.value = p.productCategoryId;
        status.value = p.status;
      }
    } catch (e) {
      debugPrint('Error loading product form data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitProduct() async {
    if (!formKey.currentState!.validate()) return;

    final shop = await _repository.fetchMyShop();
    if (shop == null || shop.id.isEmpty) {
      Get.snackbar(
        'ไม่พบร้านค้าในระบบ',
        'กรุณาลงทะเบียนและเปิดใช้งานร้านค้าก่อนทำการเพิ่มหรือแก้ไขสินค้า',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => Get.toNamed(AppRoutes.registerShop),
          child: const Text('ลงทะเบียน', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        ),
      );
      return;
    }

    isSaving.value = true;
    try {
      final payload = {
        'shopId': shop.id,
        'productName': nameController.text.trim(),
        'productCategoryId': selectedCategoryId.value,
        'price': double.tryParse(priceController.text.trim()) ?? 0.0,
        'quantity': int.tryParse(quantityController.text.trim()) ?? 0,
        'description': descriptionController.text.trim(),
        'imageUrl': imageUrlController.text.trim(),
        'status': status.value,
      };

      bool success = false;
      if (editingProduct != null) {
        success = await _repository.updateProduct(editingProduct!.id, payload);
      } else {
        success = await _repository.createProduct(payload);
      }

      if (success) {
        Get.back(result: true);
        Get.snackbar(
          'บันทึกสำเร็จ',
          editingProduct != null ? 'อัปเดตข้อมูลสินค้าแล้ว' : 'เพิ่มสินค้าใหม่เรียบร้อยแล้ว',
          backgroundColor: const Color(0xFF047857),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'เกิดข้อผิดพลาด',
          'ไม่สามารถบันทึกสินค้าได้ กรุณาลองใหม่อีกครั้ง',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'เกิดข้อผิดพลาด',
        e.toString(),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.onClose();
  }
}
