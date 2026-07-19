import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/recipe_controller.dart';
import '../../models/recipe.dart';
import '../../utils/constants.dart';
import '../../widgets/ingredient_tile.dart';
import '../recipe_form/recipe_form_page.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  Recipe? _recipe;
  late int _servings;
  bool _loadedRouteData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedRouteData) {
      return;
    }
    _recipe = ModalRoute.of(context)?.settings.arguments as Recipe?;
    _servings = _recipe?.servings ?? 1;
    _loadedRouteData = true;
  }

  @override
  Widget build(BuildContext context) {
    final recipe = _recipe;
    if (recipe == null) {
      return const Scaffold(body: Center(child: Text('ไม่พบข้อมูลสูตรอาหาร')));
    }
    final multiplier = _servings / recipe.servings;
    final controller = Get.find<RecipeController>();
    final canManage = controller.canManageRecipe(recipe);
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _HeroImage(recipe: recipe),
                  Positioned(
                    left: 16.w,
                    top: 48.h,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.45),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16.w,
                    top: 48.h,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.45),
                      child: IconButton(
                        onPressed: () => controller.toggleFavorite(recipe),
                        icon: Icon(
                          recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 8.h),
                    Text(recipe.description, style: TextStyle(fontSize: 15.sp)),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _InfoChip(icon: Icons.category, text: recipe.categoryName),
                        _InfoChip(icon: Icons.timer, text: 'เตรียม ${recipe.prepTime} นาที'),
                        _InfoChip(icon: Icons.restaurant, text: 'ปรุง ${recipe.cookTime} นาที'),
                        _InfoChip(icon: Icons.local_fire_department, text: recipe.difficulty),
                        _InfoChip(icon: Icons.star, text: recipe.rating.toStringAsFixed(1)),
                        _InfoChip(icon: Icons.person, text: recipe.ownerName),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'จำนวนเสิร์ฟ',
                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                          ),
                        ),
                        IconButton(
                          onPressed: _servings > 1 ? () => setState(() => _servings--) : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('$_servings คน', style: TextStyle(fontSize: 16.sp)),
                        IconButton(
                          onPressed: () => setState(() => _servings++),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'วัตถุดิบ',
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
                    ),
                    ...recipe.ingredients.expand(
                      (item) => [
                        IngredientTile(ingredient: item, multiplier: multiplier),
                        const Divider(),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'ขั้นตอนการทำ',
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 8.h),
                    ...recipe.steps.indexed.map(
                      (entry) => ListTile(
                        leading: CircleAvatar(child: Text('${entry.$1 + 1}')),
                        title: Text(entry.$2),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    if (canManage)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => RecipeFormPage(recipe: recipe),
                                ),
                              ),
                              icon: const Icon(Icons.edit),
                              label: const Text('แก้ไข'),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () => controller.deleteRecipe(recipe),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('ลบ'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      AppConstants.placeholderFoodAsset,
      height: 300.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 300.h,
          width: double.infinity,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.restaurant_menu),
        );
      },
    );
    if (recipe.imageUrl.isEmpty) {
      return fallback;
    }
    return Image.network(
      recipe.imageUrl,
      height: 300.h,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16.sp),
      label: Text(text),
    );
  }
}
