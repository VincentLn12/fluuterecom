import 'package:get/get.dart';
import '../models/admin_tag_model.dart';
import '../repositories/admin_repository.dart';

class AdminTagsController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final tags = <AdminTag>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final selectedStatusFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTags();
  }

  Future<void> loadTags({int page = 1}) async {
    isLoading.value = true;
    currentPage.value = page;
    try {
      final paged = await _repository.fetchAdminTags(
        status: selectedStatusFilter.value.isEmpty ? null : selectedStatusFilter.value,
        page: page,
        pageSize: 15,
      );
      if (paged != null) {
        tags.assignAll(paged.items);
        totalPages.value = paged.totalPages;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTag(String name) async {
    final res = await _repository.createTag(name);
    if (res != null) {
      Get.snackbar('สำเร็จ', 'เพิ่มแท็กใหม่เรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
      loadTags(page: 1);
      return true;
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถเพิ่มแท็กได้', snackPosition: SnackPosition.TOP);
    return false;
  }

  Future<bool> updateTag(String id, String name, String status) async {
    final ok = await _repository.updateTag(id, name, status);
    if (ok) {
      Get.snackbar('สำเร็จ', 'แก้ไขแท็กเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
      loadTags(page: currentPage.value);
      return true;
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถแก้ไขแท็กได้', snackPosition: SnackPosition.TOP);
    return false;
  }

  Future<bool> deleteTag(String id) async {
    final ok = await _repository.deleteTag(id);
    if (ok) {
      Get.snackbar('สำเร็จ', 'ลบแท็กเรียบร้อยแล้ว', snackPosition: SnackPosition.TOP);
      loadTags(page: currentPage.value);
      return true;
    }
    Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถลบแท็กได้', snackPosition: SnackPosition.TOP);
    return false;
  }
}
