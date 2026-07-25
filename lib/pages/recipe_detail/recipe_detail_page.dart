import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/recipe_controller.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key, this.recipe, this.recipeId});

  final Recipe? recipe;
  final int? recipeId;

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  Recipe? _recipe;
  var _isLoading = false;
  String _errorMessage = '';
  late int _servings;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    _servings = _safeServings(_recipe?.servings);
    _loadRecipe();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = _latestRecipe;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (recipe == null) {
      return _MissingRecipeView(
        message: _errorMessage.isEmpty
            ? 'กรุณากลับไปเลือกเมนูอีกครั้ง'
            : _errorMessage,
        onRetry: _loadRecipe,
      );
    }

    final controller = Get.find<RecipeController>();
    final canManage = controller.canManageRecipe(recipe);
    final baseServings = _safeServings(recipe.servings);
    final multiplier = _servings / baseServings;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: CustomScrollView(
        slivers: [
          _DetailHeader(
            recipe: recipe,
            onBack: Get.back,
            onFavorite: () => _toggleFavorite(recipe),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TitleBlock(recipe: recipe),
                  const SizedBox(height: 14),
                  _InfoGrid(recipe: recipe, servings: _servings),
                  const SizedBox(height: 14),
                  _ServingsControl(
                    servings: _servings,
                    baseServings: baseServings,
                    onDecrease: _servings > 1
                        ? () => setState(() => _servings--)
                        : null,
                    onIncrease: () => setState(() => _servings++),
                  ),
                  if (recipe.videoUrl.trim().isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _VideoCard(
                      videoUrl: recipe.videoUrl.trim(),
                      onOpen: () => _openVideo(recipe.videoUrl),
                      onCopy: () => _copyVideoLink(recipe.videoUrl),
                    ),
                  ],
                  const SizedBox(height: 22),
                  _Section(
                    title: 'วัตถุดิบ',
                    icon: Icons.shopping_basket_outlined,
                    child: recipe.ingredients.isEmpty
                        ? const _EmptyPanel('ยังไม่มีข้อมูลวัตถุดิบ')
                        : _IngredientList(
                            ingredients: recipe.ingredients,
                            multiplier: multiplier,
                          ),
                  ),
                  const SizedBox(height: 22),
                  _Section(
                    title: 'ขั้นตอนการทำ',
                    icon: Icons.format_list_numbered_rounded,
                    child: recipe.steps.isEmpty
                        ? const _EmptyPanel('ยังไม่มีข้อมูลขั้นตอนการทำ')
                        : _StepList(steps: recipe.steps),
                  ),
                  if (canManage) ...[
                    const SizedBox(height: 22),
                    _ManageActions(
                      onEdit: () => _confirmEdit(recipe),
                      onDelete: () async {
                        final deleted = await controller.deleteRecipe(recipe);
                        if (mounted && deleted) {
                          Get.back();
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Recipe? get _latestRecipe {
    final recipe = _recipe;
    if (recipe?.id == null || !Get.isRegistered<RecipeController>()) {
      return recipe;
    }
    final controller = Get.find<RecipeController>();
    return controller.recipes.firstWhereOrNull(
          (item) => item.id == recipe!.id,
        ) ??
        recipe;
  }

  Future<void> _loadRecipe() async {
    final recipeId = widget.recipe?.id ?? widget.recipeId;
    if (_recipe != null) {
      return;
    }
    if (recipeId == null) {
      setState(() {
        _errorMessage = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final recipe = await Get.find<RecipeController>().fetchRecipeById(
        recipeId,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _recipe = recipe;
        _servings = _safeServings(recipe.servings);
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(Recipe recipe) async {
    await Get.find<RecipeController>().toggleFavorite(recipe);
    final latestRecipe = _latestRecipe;
    if (!mounted || latestRecipe == null) {
      return;
    }
    setState(() {
      _recipe = latestRecipe;
    });
  }

  Future<void> _confirmEdit(Recipe recipe) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('ยืนยันการแก้ไข'),
        content: Text('ต้องการแก้ไข "${recipe.name}" ใช่ไหม'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('แก้ไข'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      Get.toNamed(AppRoutes.recipeForm, arguments: recipe);
    }
  }

  int _safeServings(int? value) {
    if (value == null || value < 1) {
      return 1;
    }
    return value;
  }

  Future<void> _openVideo(String videoUrl) async {
    final uri = Uri.tryParse(videoUrl.trim());
    if (uri == null) {
      Get.snackbar('ลิงก์ไม่ถูกต้อง', 'ไม่สามารถเปิดวิดีโอนี้ได้');
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    if (!opened) {
      Get.snackbar('เปิดลิงก์ไม่ได้', 'กรุณาลองคัดลอกลิงก์แล้วเปิดเอง');
    }
  }

  Future<void> _copyVideoLink(String videoUrl) async {
    await Clipboard.setData(ClipboardData(text: videoUrl.trim()));
    Get.snackbar('คัดลอกแล้ว', 'คัดลอกลิงก์วิดีโอเรียบร้อย');
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.recipe,
    required this.onBack,
    required this.onFavorite,
  });

  final Recipe recipe;
  final VoidCallback onBack;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 310,
      pinned: true,
      backgroundColor: const Color(0xFFFFF7ED),
      foregroundColor: const Color(0xFF24160F),
      leading: _RoundIconButton(
        icon: Icons.arrow_back_rounded,
        tooltip: 'ย้อนกลับ',
        onPressed: onBack,
      ),
      actions: [
        _RoundIconButton(
          icon: recipe.isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          tooltip: 'รายการโปรด',
          color: recipe.isFavorite ? Colors.redAccent : const Color(0xFF24160F),
          onPressed: onFavorite,
        ),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _FoodImage(imageUrl: recipe.imageUrl),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66000000),
                    Color(0x05000000),
                    Color(0xAA000000),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _HeaderChip(
                    icon: Icons.category_rounded,
                    text: recipe.categoryName.isEmpty
                        ? 'ไม่ระบุหมวดหมู่'
                        : recipe.categoryName,
                  ),
                  _HeaderChip(
                    icon: Icons.star_rounded,
                    text: recipe.rating.toStringAsFixed(1),
                  ),
                  _HeaderChip(
                    icon: Icons.local_fire_department_rounded,
                    text: recipe.difficulty.isEmpty
                        ? 'ไม่ระบุระดับ'
                        : recipe.difficulty,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodImage extends StatelessWidget {
  const _FoodImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      AppConstants.placeholderFoodAsset,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        color: const Color(0xFFFFD8BF),
        child: const Icon(
          Icons.restaurant_menu_rounded,
          color: Color(0xFFE85D24),
          size: 72,
        ),
      ),
    );

    if (imageUrl.trim().isEmpty) {
      return fallback;
    }

    return Image.network(
      imageUrl.trim(),
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return fallback;
      },
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: IconButton(
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.92),
          fixedSize: const Size(42, 42),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: color),
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFE85D24), size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF24160F),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
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

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.recipe, required this.servings});

  final Recipe recipe;
  final int servings;

  @override
  Widget build(BuildContext context) {
    final items = [
      _InfoTile(
        icon: Icons.schedule_rounded,
        label: 'เวลารวม',
        value: '${recipe.totalTime} นาที',
      ),
      _InfoTile(
        icon: Icons.restaurant_rounded,
        label: 'จำนวนเสิร์ฟ',
        value: '$servings คน',
      ),
      _InfoTile(
        icon: Icons.timer_outlined,
        label: 'เตรียม',
        value: '${recipe.prepTime} นาที',
      ),
      _InfoTile(
        icon: Icons.soup_kitchen_outlined,
        label: 'ปรุง',
        value: '${recipe.cookTime} นาที',
      ),
      _InfoTile(
        icon: Icons.person_outline_rounded,
        label: 'ผู้สร้าง',
        value: recipe.ownerName.isEmpty ? 'ไม่ระบุ' : recipe.ownerName,
      ),
      _InfoTile(
        icon: Icons.bookmark_border_rounded,
        label: 'หมวดหมู่',
        value: recipe.categoryName.isEmpty ? 'ไม่ระบุ' : recipe.categoryName,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 3 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          childAspectRatio: columns == 3 ? 2.35 : 2.15,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: items,
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEAD7C7)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD8BF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFE85D24), size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF8C7465),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF24160F),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
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

class _ServingsControl extends StatelessWidget {
  const _ServingsControl({
    required this.servings,
    required this.baseServings,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int servings;
  final int baseServings;
  final VoidCallback? onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF25312C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.groups_rounded, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ปรับจำนวนเสิร์ฟ\nสูตรต้นฉบับ $baseServings คน',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
          IconButton(
            tooltip: 'ลดจำนวนเสิร์ฟ',
            onPressed: onDecrease,
            color: Colors.white,
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
          SizedBox(
            width: 34,
            child: Text(
              '$servings',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            tooltip: 'เพิ่มจำนวนเสิร์ฟ',
            onPressed: onIncrease,
            color: Colors.white,
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({
    required this.videoUrl,
    required this.onOpen,
    required this.onCopy,
  });

  final String videoUrl;
  final VoidCallback onOpen;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = _VideoUrlParser.thumbnailUrl(videoUrl);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7F0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBECDD)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Color(0xFF2D9C6A),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'วิดีโอสอนทำ',
                    style: TextStyle(
                      color: Color(0xFF183C2B),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'เปิดแบบเต็มหน้า',
                  onPressed: onOpen,
                  icon: const Icon(Icons.open_in_new_rounded),
                ),
                IconButton(
                  tooltip: 'คัดลอกลิงก์',
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_rounded),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onOpen,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (thumbnailUrl == null)
                    const ColoredBox(color: Color(0xFF183C2B))
                  else
                    Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const ColoredBox(color: Color(0xFF183C2B)),
                    ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFFE85D24),
                        size: 48,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Text(
                      'แตะเพื่อเปิดวิดีโอในแอป',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              videoUrl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF315644),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoUrlParser {
  const _VideoUrlParser._();

  static String? thumbnailUrl(String rawUrl) {
    final uri = Uri.tryParse(rawUrl.trim());
    if (uri == null) {
      return null;
    }

    final host = uri.host.toLowerCase().replaceFirst('www.', '');
    final videoId = _youtubeVideoId(uri, host);
    if (videoId == null || videoId.isEmpty) {
      return null;
    }

    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  static String? _youtubeVideoId(Uri uri, String host) {
    if (host == 'youtu.be') {
      return uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
    }

    if (!host.endsWith('youtube.com')) {
      return null;
    }

    if (uri.pathSegments.isEmpty) {
      return uri.queryParameters['v'];
    }

    final firstSegment = uri.pathSegments.first;
    if (firstSegment == 'watch') {
      return uri.queryParameters['v'];
    }
    if (firstSegment == 'embed' || firstSegment == 'shorts') {
      return uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
    }

    return uri.queryParameters['v'];
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFE85D24)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF24160F),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _IngredientList extends StatelessWidget {
  const _IngredientList({required this.ingredients, required this.multiplier});

  final List<Ingredient> ingredients;
  final double multiplier;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEAD7C7)),
      ),
      child: Column(
        children: [
          for (var index = 0; index < ingredients.length; index++) ...[
            _IngredientTile(
              ingredient: ingredients[index],
              multiplier: multiplier,
            ),
            if (index != ingredients.length - 1)
              const Divider(height: 1, color: Color(0xFFF0E3D8)),
          ],
        ],
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  const _IngredientTile({required this.ingredient, required this.multiplier});

  final Ingredient ingredient;
  final double multiplier;

  @override
  Widget build(BuildContext context) {
    final amount = ingredient.amount * multiplier;
    final amountText = amount % 1 == 0
        ? amount.toInt().toString()
        : amount.toStringAsFixed(1);

    return ListTile(
      leading: const Icon(Icons.check_circle_rounded, color: Color(0xFF2D9C6A)),
      title: Text(
        ingredient.name,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      trailing: Text(
        '$amountText ${ingredient.unit}',
        style: const TextStyle(
          color: Color(0xFFE85D24),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _StepList extends StatelessWidget {
  const _StepList({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          _StepTile(index: index + 1, text: steps[index]),
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEAD7C7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: const Color(0xFFE85D24),
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF3E332B),
                fontSize: 15,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManageActions extends StatelessWidget {
  const _ManageActions({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded),
            label: const Text('แก้ไขเมนู'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('ลบเมนู'),
          ),
        ),
      ],
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEAD7C7)),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF8C7465),
          fontWeight: FontWeight.w700,
        ),
      ),
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
