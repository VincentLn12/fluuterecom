import 'package:get/get.dart';
import '../models/content_model.dart';
import '../repositories/content_repository.dart';

class ContentController extends GetxController {
  ContentController({ContentRepository? repository})
    : _repository = repository ?? ContentRepository();

  final ContentRepository _repository;

  final contents = <ContentModel>[].obs;
  final categories = <ContentCategory>[].obs;
  final districts = <District>[].obs;

  final selectedCategoryId = RxnString();
  final selectedDistrictId = RxnString();
  final searchQuery = ''.obs;

  final isLoading = false.obs;
  final displayMode = 'grid'.obs; // 'grid' | 'list'
  final viewType = 'list'.obs; // 'list' | 'map'

  void setViewType(String type) {
    viewType.value = type;
  }

  @override
  void onInit() {
    super.onInit();
    parseArguments(Get.arguments);
    initMasterDataAndFetch();
  }

  @override
  void onReady() {
    super.onReady();
    if (Get.arguments != null) {
      parseArguments(Get.arguments);
      fetchContents();
    }
  }

  void parseArguments(dynamic args) {
    if (args is Map) {
      if (args['districtId'] != null) {
        selectedDistrictId.value = args['districtId']?.toString();
      }
      if (args['categoryId'] != null) {
        selectedCategoryId.value = args['categoryId']?.toString();
      }
      if (args['search'] != null) {
        searchQuery.value = args['search']?.toString() ?? '';
      }
    }
  }

  Future<void> initMasterDataAndFetch() async {
    isLoading.value = true;
    try {
      final fetchedCategories = await _repository.fetchCategories();
      final fetchedDistricts = await _repository.fetchDistricts();
      categories.assignAll(fetchedCategories);
      districts.assignAll(fetchedDistricts);
      await fetchContents();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchContents() async {
    try {
      isLoading.value = true;
      final result = await _repository.fetchContents(
        search: searchQuery.value,
        categoryId: selectedCategoryId.value,
        districtId: selectedDistrictId.value,
      );
      contents.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String? categoryId) {
    if (selectedCategoryId.value == categoryId) {
      selectedCategoryId.value = null;
    } else {
      selectedCategoryId.value = categoryId;
    }
    fetchContents();
  }

  void selectDistrict(String? districtId) {
    if (selectedDistrictId.value == districtId) {
      selectedDistrictId.value = null;
    } else {
      selectedDistrictId.value = districtId;
    }
    fetchContents();
  }

  void setSearch(String query) {
    searchQuery.value = query;
    fetchContents();
  }

  void toggleDisplayMode() {
    displayMode.value = displayMode.value == 'grid' ? 'list' : 'grid';
  }

  void clearFilters() {
    selectedCategoryId.value = null;
    selectedDistrictId.value = null;
    searchQuery.value = '';
    fetchContents();
  }
}
