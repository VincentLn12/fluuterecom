import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'package:projecte/features/shops/views/shop_list/shop_list_palette.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({super.key, required this.item, this.displayMode = 'list'});

  final ShopModel item;
  final String displayMode;

  Future<void> _makeCall() async {
    final phone = item.phone;
    if (phone == null || phone.isEmpty) return;
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ShopListPalette.line),
        boxShadow: ShopListPalette.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.shopDetail, arguments: item),
          child: displayMode == 'featured' ? _featured() : _compact(),
        ),
      ),
    );
  }

  // 1. Featured Mode (Hero Magazine Card)
  Widget _featured() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 210,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _image(),
              // Dark gradient overlay
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x33000000),
                      Colors.transparent,
                      Color(0xB30B271F),
                    ],
                    stops: [0.0, 0.45, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Top row: Status pill & category pill
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusBadge(isDark: false),
                    if (item.categoryName?.isNotEmpty == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xCC0D2B22),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          item.categoryName!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom location tag
              if (item.districtName?.isNotEmpty == true)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: ShopListPalette.gold,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'อำเภอ${item.districtName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                color: Color(0x80000000),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Body Content
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ShopListPalette.ink,
                            fontSize: 21,
                            height: 1.25,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (item.description?.isNotEmpty == true) ...[
                          const SizedBox(height: 6),
                          Text(
                            item.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: ShopListPalette.muted,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bottom action row
              Row(
                children: [
                  // Opening hours pill if available
                  if (item.openingTime != null && item.closingTime != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ShopListPalette.surfaceMuted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 15,
                            color: ShopListPalette.muted,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${item.openingTime} - ${item.closingTime} น.',
                            style: const TextStyle(
                              fontSize: 13,
                              color: ShopListPalette.inkSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),

                  // Quick Call Button
                  if (item.phone?.isNotEmpty == true) ...[
                    _callButton(),
                    const SizedBox(width: 8),
                  ],

                  // Explore Store Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          ShopListPalette.primaryDark,
                          ShopListPalette.primary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ดูร้านค้า',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. Compact List Mode
  Widget _compact() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Image container with rounded corners & status dot
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 118,
                  height: 118,
                  child: _image(),
                ),
              ),
              Positioned(
                top: 7,
                left: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item.isOpenNow
                              ? ShopListPalette.green
                              : const Color(0xFFB0BEC5),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.isOpenNow ? 'เปิด' : 'ปิด',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Right: Shop information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Category Tag
                if (item.categoryName?.isNotEmpty == true)
                  Text(
                    item.categoryName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ShopListPalette.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                const SizedBox(height: 3),

                // Name
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ShopListPalette.ink,
                    fontSize: 17.5,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),

                // Location / District
                if (item.districtName?.isNotEmpty == true)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: ShopListPalette.muted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'อ.${item.districtName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ShopListPalette.muted,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),

                // Bottom row: phone call & view button
                Row(
                  children: [
                    if (item.openingTime != null)
                      Text(
                        '${item.openingTime} - ${item.closingTime ?? ''}',
                        style: const TextStyle(
                          color: ShopListPalette.muted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const Spacer(),
                    if (item.phone?.isNotEmpty == true) ...[
                      _callButton(),
                      const SizedBox(width: 6),
                    ],
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: ShopListPalette.surfaceMuted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        size: 22,
                        color: ShopListPalette.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge({required bool isDark}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xCC0D2B22) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.isOpenNow
                  ? ShopListPalette.green
                  : ShopListPalette.mutedLight,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            item.isOpenNow ? 'เปิดบริการอยู่' : 'ปิดบริการชั่วคราว',
            style: TextStyle(
              color: isDark ? Colors.white : ShopListPalette.ink,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _callButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _makeCall,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: ShopListPalette.orangeSoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.phone_rounded,
            size: 17,
            color: ShopListPalette.orange,
          ),
        ),
      ),
    );
  }

  Widget _image() {
    final imageUrl = item.coverImageUrl;
    if (imageUrl?.isNotEmpty == true) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE2EFEA), Color(0xFFCFE5DC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.storefront_rounded,
          size: 42,
          color: ShopListPalette.primary,
        ),
      ),
    );
  }
}
