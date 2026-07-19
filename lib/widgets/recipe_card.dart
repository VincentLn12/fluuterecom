import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/recipe.dart';
import '../utils/constants.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onFavoritePressed,
    this.onEditPressed,
    this.onDeletePressed,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onFavoritePressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _RecipeImage(imageUrl: recipe.imageUrl),
                Positioned(
                  left: 8.w,
                  top: 8.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                    child: Text(
                      recipe.categoryName,
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            recipe.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                          ),
                        ),
                        IconButton(
                          onPressed: onFavoritePressed,
                          icon: Icon(
                            recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: recipe.isFavorite ? Colors.redAccent : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      recipe.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _Meta(icon: Icons.schedule, text: '${recipe.totalTime} นาที'),
                        SizedBox(width: 10.w),
                        _Meta(icon: Icons.local_fire_department, text: recipe.difficulty),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 17.sp),
                        SizedBox(width: 4.w),
                        Text(recipe.rating.toStringAsFixed(1)),
                        const Spacer(),
                        if (onEditPressed != null)
                          IconButton(
                            tooltip: 'แก้ไข',
                            onPressed: onEditPressed,
                            icon: const Icon(Icons.edit),
                          ),
                        if (onDeletePressed != null)
                          IconButton(
                            tooltip: 'ลบ',
                            onPressed: onDeletePressed,
                            icon: const Icon(Icons.delete_outline),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      AppConstants.placeholderFoodAsset,
      width: 116.w,
      height: 150.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 116.w,
          height: 150.h,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.restaurant_menu),
        );
      },
    );
    if (imageUrl.isEmpty) {
      return fallback;
    }
    return Image.network(
      imageUrl,
      width: 116.w,
      height: 150.h,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.sp),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
