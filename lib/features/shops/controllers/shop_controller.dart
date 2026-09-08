import 'package:get/get.dart';
import '../../contents/models/content_model.dart';
import '../models/category_model.dart';
import '../models/shop_model.dart';
import '../repositories/shop_repository.dart';

class ShopController extends GetxController {
  ShopController({ShopRepository? repository})
      : _repository = repository ?? ShopRepository();

  final ShopRepository _repository;

  final shops = <ShopModel>[].obs;
  final categories = <ShopCategory>[].obs;
  final districts = <District>[].obs;

  final selectedCategoryId = RxnString();
  final selectedDistrictId = RxnString();
  final searchQuery = ''.obs;

  final isLoading = false.obs;
  final displayMode = 'grid'.obs; // 'grid' | 'list'
  final viewType = 'list'.obs; // 'list' | 'map'

  @override
  void onInit() {
    super.onInit();
    initMasterDataAndFetch();
  }

  Future<void> initMasterDataAndFetch() async {
    isLoading.value = true;
    try {
      final fetchedCategories = await _repository.fetchShopCategories();
      final fetchedDistricts = await _repository.fetchDistricts();
      categories.assignAll(fetchedCategories);
      districts.assignAll(fetchedDistricts);
      await fetchShops();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchShops() async {
    try {
      isLoading.value = true;
      final result = await _repository.fetchShops(
        search: searchQuery.value,
        categoryId: selectedCategoryId.value,
        districtId: selectedDistrictId.value,
      );
      shops.assignAll(result);
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
    fetchShops();
  }

  void selectDistrict(String? districtId) {
    if (selectedDistrictId.value == districtId) {
      selectedDistrictId.value = null;
    } else {
      selectedDistrictId.value = districtId;
    }
    fetchShops();
  }

  void setSearch(String query) {
    searchQuery.value = query;
    fetchShops();
  }

  void toggleDisplayMode() {
    displayMode.value = displayMode.value == 'grid' ? 'list' : 'grid';
  }

  void setViewType(String type) {
    viewType.value = type;
  }

  void clearFilters() {
    selectedCategoryId.value = null;
    selectedDistrictId.value = null;
    searchQuery.value = '';
    fetchShops();
  }
}
