import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/recipe_detail_controller.dart';
import '../../models/recipe.dart';
import 'widgets/recipe_detail_widgets.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key, this.recipe, this.recipeId});

  final Recipe? recipe;
  final int? recipeId;

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late final String tag;
  late final RecipeDetailController controller;

  @override
  void initState() {
    super.initState();
    tag = (widget.recipe?.id ?? widget.recipeId ?? DateTime.now().millisecondsSinceEpoch).toString();
    controller = Get.put(
      RecipeDetailController(initialRecipe: widget.recipe, initialRecipeId: widget.recipeId),
      tag: tag,
    );
  }



  @override
  void dispose() {
    Get.delete<RecipeDetailController>(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: Obx(() {
        final currentRecipe = controller.latestRecipe;
        final isLoading = controller.isLoading.value;
        final errorMessage = controller.errorMessage.value;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (currentRecipe == null) {
          return _MissingRecipeView(
            message: errorMessage.isEmpty
                ? 'กรุณากลับไปเลือกเมนูอีกครั้ง'
                : errorMessage,
            onRetry: controller.loadRecipe,
          );
        }

        return CustomScrollView(
          slivers: [
            DetailHeader(
              recipe: currentRecipe,
              onBack: () => Get.back(),
              onFavorite: controller.toggleFavorite,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TitleBlock(recipe: currentRecipe),
                    const SizedBox(height: 16),
                    QuickStats(recipe: currentRecipe, servings: controller.servings.value),
                    const SizedBox(height: 16),
                    ServingsControl(
                      servings: controller.servings.value,
                      baseServings: currentRecipe.servings,
                      onDecrease: controller.servings.value > 1
                          ? controller.decreaseServings
                          : null,
                      onIncrease: controller.increaseServings,
                    ),
                    if (currentRecipe.videoUrl.trim().isNotEmpty) ...[
                      const SizedBox(height: 14),
                      VideoCard(
                        videoUrl: currentRecipe.videoUrl.trim(),
                        onOpen: controller.openVideo,
                        onCopy: controller.copyVideoLink,
                      ),
                    ],
                    const SizedBox(height: 22),
                    Section(
                      title: 'วัตถุดิบ',
                      subtitle: '${currentRecipe.ingredients.length} รายการ',
                      icon: Icons.shopping_basket_outlined,
                      child: currentRecipe.ingredients.isEmpty
                          ? const EmptyPanel('ยังไม่มีข้อมูลวัตถุดิบ')
                          : IngredientList(
                              ingredients: currentRecipe.ingredients,
                              multiplier: controller.multiplier,
                            ),
                    ),
                    const SizedBox(height: 22),
                    Section(
                      title: 'ขั้นตอนการทำ',
                      subtitle: '${currentRecipe.steps.length} ขั้นตอน',
                      icon: Icons.format_list_numbered_rounded,
                      child: currentRecipe.steps.isEmpty
                          ? const EmptyPanel('ยังไม่มีข้อมูลขั้นตอนการทำ')
                          : StepList(steps: currentRecipe.steps),
                    ),
                    if (controller.canManage) ...[
                      const SizedBox(height: 22),
                      ManageActions(
                        onEdit: controller.confirmEdit,
                        onDelete: controller.deleteRecipe,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.name,
          style: const TextStyle(
            color: Color(0xFF24160F),
            fontSize: 30,
            fontWeight: FontWeight.w900,
            height: 1.12,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          recipe.description.trim().isEmpty
              ? 'ยังไม่มีคำอธิบายสำหรับเมนูนี้'
              : recipe.description.trim(),
          style: const TextStyle(
            color: Color(0xFF5E4D43),
            fontSize: 16,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _MissingRecipeView extends StatelessWidget {
  const _MissingRecipeView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายละเอียดเมนู')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.restaurant_menu_rounded,
                color: Color(0xFFE85D24),
                size: 64,
              ),
              const SizedBox(height: 14),
              const Text(
                'ไม่พบข้อมูลเมนู',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('ลองโหลดอีกครั้ง'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
