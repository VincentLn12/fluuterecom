import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/category_controller.dart';
import '../../controllers/recipe_controller.dart';
import '../../models/category.dart';
import '../../models/recipe.dart';
import '../../routes/app_routes.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeController = Get.find<RecipeController>();
    final categoryController = Get.find<CategoryController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.restaurant_menu), text: 'สูตรอาหาร'),
              Tab(icon: Icon(Icons.category), text: 'ประเภทอาหาร'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Manage Recipes
            Obx(() {
              if (recipeController.isLoading.value && recipeController.recipes.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return Scaffold(
                body: ListView.builder(
                  padding: EdgeInsets.all(10.w),
                  itemCount: recipeController.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipeController.recipes[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6.h),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: recipe.imageUrl.trim().isNotEmpty
                              ? Image.network(
                                  recipe.imageUrl,
                                  width: 50.w,
                                  height: 50.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                                )
                              : _buildPlaceholderImage(),
                        ),
                        title: Text(
                          recipe.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          recipe.categoryName.isEmpty ? 'ไม่ระบุประเภท' : recipe.categoryName,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => Get.toNamed(
                                AppRoutes.recipeForm,
                                arguments: recipe,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDeleteRecipe(recipe),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: 'add_recipe_btn',
                  tooltip: 'เพิ่มสูตรอาหารใหม่',
                  onPressed: () => Get.toNamed(AppRoutes.recipeForm),
                  child: const Icon(Icons.add),
                ),
              );
            }),

            // Tab 2: Manage Categories
            Obx(() {
              if (categoryController.isLoading.value && categoryController.categories.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return Scaffold(
                body: ListView.builder(
                  padding: EdgeInsets.all(10.w),
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6.h),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: category.imageUrl.trim().isNotEmpty
                              ? Image.network(
                                  category.imageUrl,
                                  width: 50.w,
                                  height: 50.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                                )
                              : _buildPlaceholderImage(),
                        ),
                        title: Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showCategoryDialog(context, category: category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDeleteCategory(category),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: 'add_category_btn',
                  tooltip: 'เพิ่มหมวดหมู่ใหม่',
                  onPressed: () => _showCategoryDialog(context),
                  child: const Icon(Icons.add),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 50.w,
      height: 50.w,
      color: const Color(0xFFFFD8BF),
      child: const Icon(Icons.restaurant_menu, color: Color(0xFFE85D24)),
    );
  }

  void _showCategoryDialog(BuildContext context, {Category? category}) {
    final nameController = TextEditingController(text: category?.name);
    final imageController = TextEditingController(text: category?.imageUrl);
    final categoryController = Get.find<CategoryController>();

    Get.dialog(
      AlertDialog(
        title: Text(category == null ? 'เพิ่มหมวดหมู่ใหม่' : 'แก้ไขหมวดหมู่'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อหมวดหมู่',
                hintText: 'เช่น อาหารไทย อาหารคลีน',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'ลิงก์รูปภาพ',
                hintText: 'ใส่ URL รูปภาพหมวดหมู่',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                Get.snackbar('ข้อผิดพลาด', 'กรุณากรอกชื่อหมวดหมู่');
                return;
              }
              final newCategory = Category(
                id: category?.id,
                name: nameController.text.trim(),
                imageUrl: imageController.text.trim(),
              );
              Get.back();
              if (category == null) {
                categoryController.addCategory(newCategory);
              } else {
                categoryController.updateCategory(newCategory);
              }
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCategory(Category category) {
    final categoryController = Get.find<CategoryController>();
    Get.dialog(
      AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบหมวดหมู่ "${category.name}" ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              categoryController.deleteCategory(category);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('ลบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteRecipe(Recipe recipe) {
    final recipeController = Get.find<RecipeController>();
    Get.dialog(
      AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบสูตรอาหาร "${recipe.name}" ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              recipeController.deleteRecipe(recipe);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('ลบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
