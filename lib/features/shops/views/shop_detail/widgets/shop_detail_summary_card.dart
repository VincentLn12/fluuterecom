import 'package:flutter/material.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'shop_detail_action_bar.dart';

class ShopDetailHeaderCard extends StatelessWidget {
  final ShopModel shop;
  final double rating;
  final int reviewCount;
  final int productCount;
  final bool isFollowing;
  final VoidCallback onToggleFollow;
  final VoidCallback onShare;
  final VoidCallback onDirections;

  const ShopDetailHeaderCard({
    super.key,
    required this.shop,
    required this.rating,
    required this.reviewCount,
    required this.productCount,
    required this.isFollowing,
    required this.onToggleFollow,
    required this.onShare,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = shop.isOpenNow;
    final logoImage = shop.coverImageUrl ?? shop.backgroundImageUrl;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE0EAE6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F382C).withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Floating Logo + Title & Badges
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store Logo
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE0EAE6), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: logoImage != null && logoImage.isNotEmpty
                      ? Image.network(
                          logoImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildLogoPlaceholder(),
                        )
                      : _buildLogoPlaceholder(),
                ),
              ),
              const SizedBox(width: 14),

              // Title & Badges
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges (Category & District)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (shop.categoryName != null &&
                            shop.categoryName!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE76F51), Color(0xFFF4A261)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              shop.categoryName!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (shop.districtName != null &&
                            shop.districtName!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF6F3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'อ.${shop.districtName}',
                              style: const TextStyle(
                                color: Color(0xFF2A9D8F),
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Shop Name (Display full name without truncation)
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: shop.name,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D2B22),
                              height: 1.25,
                            ),
                          ),
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF2A9D8F),
                                size: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFE0EAE6), height: 1),
          const SizedBox(height: 14),

          // Row 2: Stats (Rating, Product Count, Opening Status & Hours)
          Row(
            children: [
              // Rating
              Expanded(
                child: _buildStatItem(
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFE9C46A),
                  title: rating > 0 ? rating.toStringAsFixed(1) : 'NEW',
                  subtitle: '$reviewCount รีวิว',
                ),
              ),

              _buildVerticalDivider(),

              // Product Count
              Expanded(
                child: _buildStatItem(
                  icon: Icons.inventory_2_rounded,
                  iconColor: const Color(0xFF2A9D8F),
                  title: '$productCount',
                  subtitle: 'รายการสินค้า',
                ),
              ),

              _buildVerticalDivider(),

              // Status & Hours
              Expanded(
                child: _buildStatItem(
                  icon: isOpen
                      ? Icons.storefront_rounded
                      : Icons.do_not_disturb_on_rounded,
                  iconColor: isOpen
                      ? const Color(0xFF2A9D8F)
                      : const Color(0xFFE76F51),
                  title: isOpen ? 'เปิดบริการ' : 'ปิดให้บริการ',
                  titleColor: isOpen
                      ? const Color(0xFF2A9D8F)
                      : const Color(0xFFE76F51),
                  subtitle: shop.openingTime != null && shop.closingTime != null
                      ? '${shop.openingTime}-${shop.closingTime}'
                      : 'เปิดทุกวัน',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Row 3: Action Buttons (Follow)
          ShopDetailActionBar(
            isFollowing: isFollowing,
            onToggleFollow: onToggleFollow,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? titleColor,
    required String subtitle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? const Color(0xFF0D2B22),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2.5),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF5A7B70),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 34, color: const Color(0xFFE0EAE6));
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      color: const Color(0xFF1B4D3E),
      child: const Center(
        child: Icon(Icons.storefront_rounded, size: 34, color: Colors.white),
      ),
    );
  }
}
