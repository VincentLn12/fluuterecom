import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/navigation_controller.dart';
import '../../controllers/recipe_controller.dart';
import '../../models/recipe.dart';
import '../../utils/constants.dart';
import '../../widgets/category_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/recipe_card.dart';
import '../recipe_detail/recipe_detail_page.dart';
import '../recipe_form/recipe_form_page.dart';

class HomePage extends GetView<RecipeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าแรก'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: const CircleAvatar(
              backgroundImage: AssetImage(AppConstants.defaultProfileAsset),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(72.h),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
            child: TextField(
              readOnly: true,
              onTap: () => Get.find<NavigationController>().changeIndex(1),
              decoration: const InputDecoration(
                hintText: 'ค้นหาสูตรอาหาร',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.recipes.isEmpty) {
            return const LoadingWidget();
          }
          if (controller.errorMessage.isNotEmpty && controller.recipes.isEmpty) {
            return EmptyState(
              icon: Icons.wifi_off,
              title: 'โหลดข้อมูลไม่ได้',
              message: controller.errorMessage.value,
              buttonText: 'ลองใหม่',
              onPressed: controller.fetchRecipes,
            );
          }
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              _Banner(recipe: controller.recipes.firstOrNull),
              SizedBox(height: 22.h),
              _SectionHeader(title: 'หมวดหมู่อาหาร', onPressed: controller.clearFilters),
              SizedBox(
                height: 104.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return CategoryItem(
                      category: category,
                      onTap: () {
                        controller.filterRecipes(categoryId: category.id);
                        Get.find<NavigationController>().changeIndex(1);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 22.h),
              const _SectionHeader(title: 'สูตรอาหารแนะนำ'),
              ...controller.recipes.take(3).map((recipe) => RecipeCard(
                    recipe: recipe,
                    onTap: () => _openDetail(context, recipe),
                    onFavoritePressed: () => controller.toggleFavorite(recipe),
                    onEditPressed:
                        controller.canManageRecipe(recipe) ? () => _openForm(context, recipe) : null,
                    onDeletePressed: controller.canManageRecipe(recipe)
                        ? () => controller.deleteRecipe(recipe)
                        : null,
                  )),
              SizedBox(height: 8.h),
              const _SectionHeader(title: 'สูตรอาหารทั้งหมด'),
              ...controller.recipes.map((recipe) => RecipeCard(
                    recipe: recipe,
                    onTap: () => _openDetail(context, recipe),
                    onFavoritePressed: () => controller.toggleFavorite(recipe),
                  )),
            ],
          );
        }),
      ),
    );
  }

  void _openDetail(BuildContext context, Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const RecipeDetailPage(),
        settings: RouteSettings(arguments: recipe),
      ),
    );
  }

  void _openForm(BuildContext context, Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => RecipeFormPage(recipe: recipe),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.recipe});

  final Recipe? recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 164.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppConstants.placeholderFoodAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ColoredBox(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const Center(child: Icon(Icons.restaurant_menu)),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.32)),
          ),
          Positioned(
            left: 18.w,
            right: 18.w,
            bottom: 18.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เมนูแนะนำวันนี้',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  recipe?.name ?? 'เริ่มสร้างสูตรแรกของคุณ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onPressed});

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
            ),
          ),
          if (onPressed != null)
            TextButton(onPressed: onPressed, child: const Text('ทั้งหมด')),
        ],
      ),
    );
  }
}
