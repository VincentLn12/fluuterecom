import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/recipe_controller.dart';
import '../../models/recipe.dart';
import '../../routes/app_navigator.dart';
import '../../utils/constants.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/recipe_card.dart';

class SearchPage extends GetView<RecipeController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ค้นหา')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              TextField(
                onChanged: controller.searchRecipes,
                decoration: const InputDecoration(
                  hintText: 'ชื่อเมนู หมวดหมู่ หรือวัตถุดิบ',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 12.h),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('ทั้งหมด'),
                        selected: controller.selectedCategoryId.value == null,
                        onSelected: (_) => controller.filterRecipes(categoryId: 0),
                      ),
                      SizedBox(width: 8.w),
                      ...controller.categories.map(
                        (category) => Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: ChoiceChip(
                            label: Text(category.name),
                            selected: controller.selectedCategoryId.value == category.id,
                            onSelected: (_) => controller.filterRecipes(categoryId: category.id),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => DropdownButtonFormField<String>(
                        initialValue: controller.selectedDifficulty.value.isEmpty
                            ? null
                            : controller.selectedDifficulty.value,
                        hint: const Text('ระดับความยาก'),
                        items: AppConstants.difficulties
                            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                            .toList(),
                        onChanged: (value) => controller.filterRecipes(difficulty: value ?? ''),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  TextButton(
                    onPressed: controller.clearFilters,
                    child: const Text('ล้างตัวกรอง'),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: Obx(() {
                  if (controller.filteredRecipes.isEmpty) {
                    return const EmptyState(
                      icon: Icons.search_off,
                      title: 'ไม่พบสูตรอาหาร',
                      message: 'ลองเปลี่ยนคำค้นหาหรือตัวกรองอีกครั้ง',
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = controller.filteredRecipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () => _openDetail(recipe),
                        onFavoritePressed: () => controller.toggleFavorite(recipe),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetail(Recipe recipe) {
    AppNavigator.openRecipeDetail(recipe);
  }
}
