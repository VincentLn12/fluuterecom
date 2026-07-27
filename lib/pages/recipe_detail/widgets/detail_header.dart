import 'package:flutter/material.dart';
import '../../../models/recipe.dart';
import '../../../utils/constants.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({
    super.key,
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
      leading: RoundIconButton(
        icon: Icons.arrow_back_rounded,
        tooltip: 'ย้อนกลับ',
        onPressed: onBack,
      ),
      actions: [
        RoundIconButton(
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
            FoodImage(imageUrl: recipe.imageUrl),
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
                  HeaderChip(
                    icon: Icons.category_rounded,
                    text: recipe.categoryName.isEmpty
                        ? 'ไม่ระบุหมวดหมู่'
                        : recipe.categoryName,
                  ),
                  HeaderChip(
                    icon: Icons.star_rounded,
                    text: recipe.rating.toStringAsFixed(1),
                  ),
                  HeaderChip(
                    icon: Icons.person_rounded,
                    text: recipe.ownerName.isEmpty
                        ? 'ไม่ระบุผู้สร้าง'
                        : recipe.ownerName,
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

class FoodImage extends StatelessWidget {
  const FoodImage({super.key, required this.imageUrl});

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

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
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

class HeaderChip extends StatelessWidget {
  const HeaderChip({super.key, required this.icon, required this.text});

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
