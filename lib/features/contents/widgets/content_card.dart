import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../models/content_model.dart';

class ContentCard extends StatefulWidget {
  final ContentModel item;
  final String displayMode; // 'grid' | 'list'
  final int index;

  const ContentCard({
    super.key,
    required this.item,
    this.displayMode = 'grid',
    this.index = 0,
  });

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGrid = widget.displayMode == 'grid';

    // Staggered Entry Animation Delay calculation based on index
    final animDelay = (widget.index % 6) * 50;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 380 + animDelay),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Opacity(
          opacity: animValue.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1.0 - animValue) * 24),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          Get.toNamed(AppRoutes.contentDetail, arguments: widget.item);
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isPressed
                    ? const Color(0xFFD96C2C)
                    : const Color(0xFFEFE5DA),
                width: _isPressed ? 1.8 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF2B1F17,
                  ).withValues(alpha: _isPressed ? 0.15 : 0.08),
                  blurRadius: _isPressed ? 6 : 16,
                  offset: Offset(0, _isPressed ? 2 : 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: isGrid ? _buildGridContent(theme) : _buildListContent(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildGridContent(ThemeData theme) {
    final hasVideo =
        widget.item.youtubeUrl != null &&
        widget.item.youtubeUrl!.trim().isNotEmpty;

    final locationParts = [
      if (widget.item.shopName != null && widget.item.shopName!.isNotEmpty)
        widget.item.shopName,
      if (widget.item.districtName != null &&
          widget.item.districtName!.isNotEmpty)
        'อ.${widget.item.districtName}',
      if (widget.item.subDistrictName != null &&
          widget.item.subDistrictName!.isNotEmpty)
        'ต.${widget.item.subDistrictName}',
    ];
    final locationText = locationParts.join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Header with overlays (16:9 Aspect ratio for 1 card per row)
        Stack(
          children: [
            AspectRatio(aspectRatio: 16 / 9, child: _buildImage()),
            // Gradient Overlay for text/badge readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.45),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.40),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
            // Category Badge (Top Left)
            if (widget.item.categoryName != null)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE07A3B), Color(0xFFC45A1B)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.item.categoryName!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Rating Badge (Top Right)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE9C46A).withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 15,
                      color: Color(0xFFFFD166),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      widget.item.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Video Indicator Icon Overlay
            if (hasVideo)
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white70, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            // District / Shop Location Badge (Bottom Left)
            if (locationText.isNotEmpty)
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1713).withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFFE9C46A),
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              locationText,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
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

        // Body Info & CTA Button
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B1F17),
                  height: 1.3,
                ),
              ),
              if (widget.item.description != null &&
                  widget.item.description!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  widget.item.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.35,
                  ),
                ),
              ],
              if (widget.item.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: widget.item.tags.take(3).map((tag) {
                    return Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFD96C2C),
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 15,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.item.viewCount} เข้าชม',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD96C2C), Color(0xFFC45A1B)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFD96C2C,
                          ).withValues(alpha: 0.35),
                          blurRadius: _isPressed ? 2 : 5,
                          offset: Offset(0, _isPressed ? 1 : 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'เปิดอ่าน',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        AnimatedPadding(
                          duration: const Duration(milliseconds: 140),
                          padding: EdgeInsets.only(left: _isPressed ? 6 : 3),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
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

  Widget _buildListContent(ThemeData theme) {
    final hasVideo =
        widget.item.youtubeUrl != null &&
        widget.item.youtubeUrl!.trim().isNotEmpty;

    final locationParts = [
      if (widget.item.shopName != null && widget.item.shopName!.isNotEmpty)
        widget.item.shopName,
      if (widget.item.districtName != null &&
          widget.item.districtName!.isNotEmpty)
        'อ.${widget.item.districtName}',
    ];
    final locationText = locationParts.join(' · ');

    return SizedBox(
      height: 148,
      child: Row(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 138,
                height: double.infinity,
                child: _buildImage(),
              ),
              if (hasVideo)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: Color(0xFFFFD166),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        widget.item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.item.categoryName != null)
                        Text(
                          widget.item.categoryName!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD96C2C),
                          ),
                        ),
                      const SizedBox(height: 3),
                      Text(
                        widget.item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B1F17),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (locationText.isNotEmpty)
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 13,
                                color: Color(0xFFD96C2C),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  locationText,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3EC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'เปิดอ่าน',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD96C2C),
                              ),
                            ),
                            AnimatedPadding(
                              duration: const Duration(milliseconds: 140),
                              padding: EdgeInsets.only(
                                left: _isPressed ? 5 : 2,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 13.5,
                                color: Color(0xFFD96C2C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final imgUrl =
        widget.item.coverImageUrl ??
        (widget.item.youtubeThumbnail.isNotEmpty
            ? widget.item.youtubeThumbnail
            : null);
    if (imgUrl != null && imgUrl.isNotEmpty) {
      return Image.network(
        imgUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD96C2C), Color(0xFF8C3818)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.travel_explore_rounded,
          size: 44,
          color: Colors.white70,
        ),
      ),
    );
  }
}
