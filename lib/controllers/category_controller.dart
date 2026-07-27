import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/category.dart';
import '../services/category_service.dart';

class CategoryController extends GetxController {
  CategoryController({CategoryService? service})
      : _service = service ?? CategoryService();

  final CategoryService _service;

  final categories = <Category>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _service.fetchCategories();
      categories.assignAll(result);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      isLoading.value = true;
      final nextId = categories.isEmpty
          ? 1
          : categories.map((c) => c.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      final categoryWithId = category.copyWith(id: nextId);
      final created = await _service.addCategory(categoryWithId);
      categories.add(created);
      _showSuccess('เพิ่มหมวดหมู่สำเร็จ');
    } catch (error) {
      _showError(error);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      isLoading.value = true;
      final updated = await _service.updateCategory(category);
      final index = categories.indexWhere((item) => item.id == updated.id);
      if (index != -1) {
        categories[index] = updated;
      }
      _showSuccess('แก้ไขหมวดหมู่สำเร็จ');
    } catch (error) {
      _showError(error);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(Category category) async {
    if (category.id == null) return;
    try {
      isLoading.value = true;
      await _service.deleteCategory(category.id!);
      categories.removeWhere((item) => item.id == category.id);
      _showSuccess('ลบหมวดหมู่สำเร็จ');
    } catch (error) {
      _showError(error);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(dynamic error) {
    Get.snackbar(
      'ข้อผิดพลาด',
      error.toString(),
      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
      colorText: Colors.red,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'สำเร็จ',
      message,
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      colorText: Colors.green,
    );
  }
}
