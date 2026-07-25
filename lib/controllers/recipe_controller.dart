import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';
import '../models/category.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

class RecipeController extends GetxController {
  RecipeController({RecipeService? service})
    : _service = service ?? RecipeService();

  final RecipeService _service;

  final recipes = <Recipe>[].obs;
  final filteredRecipes = <Recipe>[].obs;
  final categories = <Category>[].obs;
  final favoriteRecipes = <Recipe>[].obs;
  final isLoading = false.obs;
  final searchText = ''.obs;
  final selectedCategoryId = RxnInt();
  final selectedDifficulty = ''.obs;
  final errorMessage = ''.obs;

  AuthController get _authController => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _service.fetchRecipes();
      recipes.assignAll(result);
      filterRecipes();
      refreshFavoriteRecipes();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<Recipe> fetchRecipeById(int id) async {
    final cachedRecipe = recipes.firstWhereOrNull((recipe) => recipe.id == id);
    if (cachedRecipe != null) {
      return cachedRecipe;
    }

    final recipe = await _service.fetchRecipe(id);
    final index = recipes.indexWhere((item) => item.id == recipe.id);
    if (index == -1) {
      recipes.add(recipe);
    } else {
      recipes[index] = recipe;
    }
    filterRecipes();
    refreshFavoriteRecipes();
    return recipe;
  }

  Future<void> fetchCategories() async {
    try {
      final result = await _service.fetchCategories();
      categories.assignAll(result);
    } catch (error) {
      errorMessage.value = error.toString();
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      isLoading.value = true;
      final created = await _service.addRecipe(recipe);
      recipes.add(created);
      filterRecipes();
      refreshFavoriteRecipes();
    } catch (error) {
      _showError(error);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    if (!canManageRecipe(recipe)) {
      _showPermissionDenied();
      return;
    }
    try {
      isLoading.value = true;
      final updated = await _service.updateRecipe(recipe);
      final index = recipes.indexWhere((item) => item.id == updated.id);
      if (index != -1) {
        recipes[index] = updated;
      }
      filterRecipes();
      refreshFavoriteRecipes();
    } catch (error) {
      _showError(error);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteRecipe(Recipe recipe) async {
    if (recipe.id == null) {
      return false;
    }
    if (!canManageRecipe(recipe)) {
      _showPermissionDenied();
      return false;
    }
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('ต้องการลบ "${recipe.name}" ใช่ไหม'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return false;
    }
    try {
      isLoading.value = true;
      await _service.deleteRecipe(recipe.id!);
      recipes.removeWhere((item) => item.id == recipe.id);
      filterRecipes();
      refreshFavoriteRecipes();
      await Get.dialog<void>(
        AlertDialog(
          title: const Text('ลบสำเร็จ'),
          content: Text('ลบ "${recipe.name}" เรียบร้อยแล้ว'),
          actions: [
            ElevatedButton(onPressed: Get.back, child: const Text('ตกลง')),
          ],
        ),
      );
      return true;
    } catch (error) {
      _showError(error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final updated = recipe.copyWith(isFavorite: !recipe.isFavorite);
    final index = recipes.indexWhere((item) => item.id == recipe.id);
    if (index != -1) {
      recipes[index] = updated;
      filterRecipes();
      refreshFavoriteRecipes();
    }
    try {
      await _service.updateRecipe(updated);
    } catch (error) {
      if (index != -1) {
        recipes[index] = recipe;
        filterRecipes();
        refreshFavoriteRecipes();
      }
      _showError(error);
    }
  }

  void searchRecipes(String value) {
    searchText.value = value;
    filterRecipes();
  }

  void filterRecipes({
    int? categoryId,
    String? difficulty,
    bool? onlyFavorites,
  }) {
    if (categoryId != null) {
      selectedCategoryId.value = categoryId == 0 ? null : categoryId;
    }
    if (difficulty != null) {
      selectedDifficulty.value = difficulty;
    }

    final query = searchText.value.trim().toLowerCase();
    final result = recipes.where((recipe) {
      final matchesText =
          query.isEmpty ||
          recipe.name.toLowerCase().contains(query) ||
          recipe.categoryName.toLowerCase().contains(query) ||
          recipe.ingredients.any(
            (item) => item.name.toLowerCase().contains(query),
          );
      final matchesCategory =
          selectedCategoryId.value == null ||
          recipe.categoryId == selectedCategoryId.value;
      final matchesDifficulty =
          selectedDifficulty.value.isEmpty ||
          recipe.difficulty == selectedDifficulty.value;
      final matchesFavorite = onlyFavorites != true || recipe.isFavorite;
      return matchesText &&
          matchesCategory &&
          matchesDifficulty &&
          matchesFavorite;
    }).toList();

    filteredRecipes.assignAll(result);
  }

  void clearFilters() {
    searchText.value = '';
    selectedCategoryId.value = null;
    selectedDifficulty.value = '';
    filteredRecipes.assignAll(recipes);
  }

  void refreshFavoriteRecipes() {
    favoriteRecipes.assignAll(recipes.where((recipe) => recipe.isFavorite));
  }

  Category? categoryById(int? id) {
    if (id == null) {
      return null;
    }
    return categories.firstWhereOrNull((category) => category.id == id);
  }

  bool canManageRecipe(Recipe recipe) {
    return _authController.canManageRecipe(recipe);
  }

  int myRecipeCount() {
    final currentUser = _authController.currentUser.value;
    if (currentUser == null) {
      return 0;
    }
    if (currentUser.isAdmin) {
      return recipes.length;
    }
    return recipes.where((recipe) => recipe.ownerId == currentUser.id).length;
  }

  List<Recipe> manageableRecipes() {
    final currentUser = _authController.currentUser.value;
    if (currentUser == null) {
      return [];
    }
    if (currentUser.isAdmin) {
      return recipes.toList();
    }
    return recipes.where((recipe) => recipe.ownerId == currentUser.id).toList();
  }

  void _showError(Object error) {
    Get.snackbar('เกิดข้อผิดพลาด', error.toString());
  }

  void _showPermissionDenied() {
    Get.snackbar('ไม่มีสิทธิ์', 'คุณจัดการได้เฉพาะสูตรของตัวเอง');
  }
}
