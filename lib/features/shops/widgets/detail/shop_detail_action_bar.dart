import 'package:flutter/material.dart';

class ShopDetailActionBar extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onToggleFollow;
  final VoidCallback? onShare;
  final VoidCallback? onDirections;

  const ShopDetailActionBar({
    super.key,
    required this.isFollowing,
    required this.onToggleFollow,
    this.onShare,
    this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onToggleFollow,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFollowing
              ? const Color(0xFF0F382C)
              : const Color(0xFF2A9D8F),
          foregroundColor: Colors.white,
          elevation: isFollowing ? 0 : 3,
          shadowColor: const Color(0xFF2A9D8F).withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(
          isFollowing
              ? Icons.check_circle_rounded
              : Icons.add_circle_outline_rounded,
          size: 20,
        ),
        label: Text(
          isFollowing ? 'กำลังติดตาม' : 'ติดตามร้านค้า',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
