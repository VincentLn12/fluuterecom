import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/recipe_controller.dart';
import '../../models/recipe.dart';
import '../../routes/app_navigator.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants.dart';
import '../../widgets/category_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/recipe_card.dart';

class HomePage extends GetView<RecipeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 18.w,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Discover',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
              Text(
                'Home Kitchen',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          actions: [
            _AppBarAction(
              tooltip: 'รายการโปรด',
              onPressed: () {
                AppNavigator.goToTab(3);
              },
              icon: Icons.favorite_outline,
            ),
            _AppBarAction(
              tooltip: 'การแจ้งเตือน',
              onPressed: () {
                _showNotificationMessage(context);
              },
              icon: Icons.notifications_outlined,
            ),
            SizedBox(width: 8.w),
          ],
        ),
      ),

      body: SafeArea(
        top: false,
        child: Obx(() {
          // กำลังโหลดข้อมูล
          if (controller.isLoading.value && controller.recipes.isEmpty) {
            return const Center(child: LoadingWidget());
          }

          // โหลดข้อมูลผิดพลาด
          if (controller.errorMessage.isNotEmpty &&
              controller.recipes.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.wifi_off,
                title: 'โหลดข้อมูลไม่ได้',
                message: controller.errorMessage.value,
                buttonText: 'ลองใหม่',
                onPressed: controller.fetchRecipes,
              ),
            );
          }

          // ไม่มีสูตรอาหาร
          if (controller.recipes.isEmpty) {
            return _EmptyRecipeView(
              onAddPressed: () {
                _openAddRecipePage(context);
              },
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchRecipes,
            child: ListView(
              padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 34.h),
              children: [
                _HomeHeader(
                  userName:
                      authController.currentUser.value?.name ?? 'เชฟคนเก่ง',
                  recipeCount: controller.recipes.length,
                  favoriteCount: controller.favoriteRecipes.length,
                  onProfileTap: () {
                    AppNavigator.goToTab(4);
                  },
                ),

                SizedBox(height: 16.h),
                _SearchBar(
                  onTap: () {
                    AppNavigator.goToTab(1);
                  },
                ),

                SizedBox(height: 18.h),

                _InsightStrip(
                  totalRecipes: controller.recipes.length,
                  favoriteRecipes: controller.favoriteRecipes.length,
                  categories: controller.categories.length,
                  onOpenFavorites: () => AppNavigator.goToTab(3),
                ),

                SizedBox(height: 20.h),

                _Banner(
                  recipe: controller.recipes.firstOrNull,
                  onTap: controller.recipes.firstOrNull == null
                      ? null
                      : () {
                          _openDetail(context, controller.recipes.first);
                        },
                ),

                SizedBox(height: 20.h),

                _QuickMenuTile(
                  icon: Icons.favorite_rounded,
                  title: 'สูตรอาหารโปรด',
                  subtitle: 'รวมเมนูที่คุณเซฟไว้อ่านต่อได้ทันที',
                  onTap: () {
                    AppNavigator.goToTab(3);
                  },
                ),

                SizedBox(height: 18.h),

                _SectionHeader(
                  title: 'หมวดหมู่อาหาร',
                  onPressed: controller.clearFilters,
                ),

                SizedBox(
                  height: 116.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];

                      return CategoryItem(
                        category: category,
                        onTap: () {
                          controller.filterRecipes(categoryId: category.id);
                          AppNavigator.goToTab(1);
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 18.h),

                const _SectionHeader(
                  title: 'สูตรอาหารแนะนำ',
                  subtitle: 'คัดเมนูเด่นที่เหมาะกับการทำวันนี้',
                ),

                ...controller.recipes
                    .take(3)
                    .map(
                      (recipe) => RecipeCard(
                        recipe: recipe,
                        onTap: () {
                          _openDetail(context, recipe);
                        },
                        onFavoritePressed: () {
                          controller.toggleFavorite(recipe);
                        },
                      ),
                    ),

                SizedBox(height: 18.h),

                _SectionHeader(
                  title: 'สูตรอาหารทั้งหมด',
                  subtitle: 'เลือกดูทุกเมนูหรือเปิดหน้าค้นหาเพื่อกรองเพิ่ม',
                  onPressed: () {
                    controller.clearFilters();
                    AppNavigator.goToTab(1);
                  },
                ),

                ...controller.recipes.map(
                  (recipe) => RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      _openDetail(context, recipe);
                    },
                    onFavoritePressed: () {
                      controller.toggleFavorite(recipe);
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // เปิดหน้ารายละเอียดสูตรอาหาร
  void _openDetail(BuildContext context, Recipe recipe) {
    AppNavigator.openRecipeDetail(recipe);
  }

  // ตัวอย่างเปิดหน้าเพิ่มสูตรอาหาร
  void _openAddRecipePage(BuildContext context) {
    Get.toNamed(AppRoutes.recipeForm);
  }

  // แสดงข้อความเมื่อกดแจ้งเตือน
  void _showNotificationMessage(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('ยังไม่มีการแจ้งเตือนใหม่')));
  }
}

class _AppBarAction extends StatelessWidget {
  const _AppBarAction({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.r),
        child: Tooltip(
          message: tooltip,
          child: Ink(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            child: Icon(icon, color: colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.recipe, this.onTap});

  final Recipe? recipe;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        height: 220.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.18),
              blurRadius: 34,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // รูปพื้นหลัง
            Positioned.fill(
              child: recipe != null && recipe!.imageUrl.isNotEmpty
                  ? Image.network(
                      recipe!.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppConstants.placeholderFoodAsset,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      AppConstants.placeholderFoodAsset,
                      fit: BoxFit.cover,
                    ),
            ),

            // Gradient ทับรูปภาพ
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.22),
                      Colors.black.withValues(alpha: 0.82),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 18.w,
              top: 18.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(99.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Theme.of(context).colorScheme.primary,
                      size: 15.sp,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 18.w,
              right: 18.w,
              bottom: 20.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เมนูแนะนำวันนี้',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.90),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    recipe?.name ?? 'เริ่มสร้างสูตรแรกของคุณ',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      height: 1.04,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      _BannerStat(
                        icon: Icons.schedule,
                        label: recipe == null
                            ? 'เริ่มทำเมนูแรก'
                            : '${recipe!.totalTime} นาที',
                      ),
                      SizedBox(width: 8.w),
                      _BannerStat(
                        icon: Icons.local_fire_department_outlined,
                        label: recipe?.difficulty ?? 'ทุกระดับ',
                      ),
                      SizedBox(width: 8.w),
                      _BannerStat(
                        icon: Icons.star_rounded,
                        label: recipe?.rating.toStringAsFixed(1) ?? 'ใหม่',
                      ),
                    ],
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

class _BannerStat extends StatelessWidget {
  const _BannerStat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14.sp),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.userName,
    required this.recipeCount,
    required this.favoriteCount,
    required this.onProfileTap,
  });

  final String userName;
  final int recipeCount;
  final int favoriteCount;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.14),
            colorScheme.secondary.withValues(alpha: 0.10),
            colorScheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สวัสดี, $userName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'วันนี้อยากทำเมนูไหนดี?',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'มีสูตรพร้อมทำ $recipeCount เมนู และเมนูโปรด $favoriteCount รายการ',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 14.w),
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.78),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.10),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 27.r,
                    backgroundImage: const AssetImage(AppConstants.boy),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _HeaderMetric(
                  label: 'เมนูทั้งหมด',
                  value: '$recipeCount',
                  icon: Icons.menu_book_rounded,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _HeaderMetric(
                  label: 'Favorite',
                  value: '$favoriteCount',
                  icon: Icons.favorite_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
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

class _InsightStrip extends StatelessWidget {
  const _InsightStrip({
    required this.totalRecipes,
    required this.favoriteRecipes,
    required this.categories,
    required this.onOpenFavorites,
  });

  final int totalRecipes;
  final int favoriteRecipes;
  final int categories;
  final VoidCallback onOpenFavorites;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _MiniInsight(
              icon: Icons.auto_awesome_rounded,
              title: 'พร้อมทำ',
              value: '$totalRecipes เมนู',
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _MiniInsight(
              icon: Icons.grid_view_rounded,
              title: 'หมวดหมู่',
              value: '$categories แบบ',
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: InkWell(
              onTap: onOpenFavorites,
              borderRadius: BorderRadius.circular(18.r),
              child: _MiniInsight(
                icon: Icons.favorite_rounded,
                title: 'Favorite',
                value: '$favoriteRecipes รายการ',
                highlight: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInsight extends StatelessWidget {
  const _MiniInsight({
    required this.icon,
    required this.title,
    required this.value,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = highlight
        ? colorScheme.primary.withValues(alpha: 0.10)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 18.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'ค้นหาสูตร วัตถุดิบ หรือหมวดหมู่',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle, this.onPressed});

  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onPressed != null)
            TextButton(onPressed: onPressed, child: const Text('ทั้งหมด')),
        ],
      ),
    );
  }
}

class _QuickMenuTile extends StatelessWidget {
  const _QuickMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.12),
            colorScheme.secondary.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24.r,
          backgroundColor: Colors.white.withValues(alpha: 0.82),
          child: Icon(icon, color: colorScheme.primary),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.sp),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _EmptyRecipeView extends StatelessWidget {
  const _EmptyRecipeView({required this.onAddPressed});

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                size: 54.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'ยังไม่มีสูตรอาหาร',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 8.h),
            Text(
              'เริ่มต้นสร้างสูตรอาหารแรกของคุณได้เลย',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 22.h),
            ElevatedButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add),
              label: const Text('เพิ่มสูตรอาหาร'),
            ),
          ],
        ),
      ),
    );
  }
}
