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
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.45),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 178.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _RecipeImage(imageUrl: recipe.imageUrl),
                  Positioned(
                    left: 10.w,
                    top: 10.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                      child: Text(
                        recipe.categoryName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 10.h, 10.w, 10.h),
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
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: recipe.isFavorite
                                  ? Colors.redAccent.withValues(alpha: 0.12)
                                  : colorScheme.surfaceContainerHighest,
                            ),
                            onPressed: onFavoritePressed,
                            icon: Icon(
                              recipe.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: recipe.isFavorite
                                  ? Colors.redAccent
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        recipe.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _Meta(
                            icon: Icons.schedule,
                            text: '${recipe.totalTime} นาที',
                          ),
                          SizedBox(width: 10.w),
                          _Meta(
                            icon: Icons.local_fire_department,
                            text: recipe.difficulty,
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      const Spacer(),
                      _CardActions(
                        rating: recipe.rating,
                        onDetailPressed: onTap,
                        onEditPressed: onEditPressed,
                        onDeletePressed: onDeletePressed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardActions extends StatelessWidget {
  const _CardActions({
    required this.rating,
    required this.onDetailPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final double rating;
  final VoidCallback onDetailPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.star_rounded, color: const Color(0xFFFFB300), size: 17.sp),
        SizedBox(width: 3.w),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.sp),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                foregroundColor: colorScheme.primary,
              ),
              onPressed: onDetailPressed,
              icon: Icon(Icons.visibility_outlined, size: 15.sp),
              label: Text(
                'รายละเอียด',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
        if (onEditPressed != null) ...[
          SizedBox(width: 2.w),
          _TinyActionButton(
            tooltip: 'แก้ไข',
            icon: Icons.edit_outlined,
            onPressed: onEditPressed!,
          ),
        ],
        if (onDeletePressed != null) ...[
          SizedBox(width: 2.w),
          _TinyActionButton(
            tooltip: 'ลบ',
            icon: Icons.delete_outline,
            onPressed: onDeletePressed!,
          ),
        ],
      ],
    );
  }
}

class _TinyActionButton extends StatelessWidget {
  const _TinyActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 30.w,
      child: IconButton(
        tooltip: tooltip,
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 16.sp),
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
      width: 128.w,
      height: 178.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 128.w,
          height: 178.h,
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
      width: 128.w,
      height: 178.h,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(99.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: colorScheme.primary),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
