import 'package:flutter/material.dart';
import 'package:projecte/features/shops/models/shop_model.dart';

class ShopDetailHero extends StatelessWidget {
  final ShopModel shop;

  const ShopDetailHero({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final coverImage = shop.coverImageUrl ?? shop.backgroundImageUrl;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Cover Image Banner
        if (coverImage != null && coverImage.isNotEmpty)
          Image.network(
            coverImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildDefaultBanner(),
          )
        else
          _buildDefaultBanner(),

        // Top Gradient Shadow Overlay
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.6),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultBanner() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F382C), Color(0xFF1B4D3E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.storefront_rounded, size: 70, color: Colors.white24),
      ),
    );
  }
}
