import 'package:flutter/material.dart';

class ShopDetailBottomBar extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onToggleFollow;
  final VoidCallback onCall;
  final VoidCallback onDirections;

  const ShopDetailBottomBar({
    super.key,
    required this.isFollowing,
    required this.onToggleFollow,
    required this.onCall,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // 1. Phone Call Icon Button
            Material(
              color: const Color(0xFFEBF6F3),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: onCall,
                borderRadius: BorderRadius.circular(16),
                child: const Padding(
                  padding: EdgeInsets.all(13),
                  child: Icon(
                    Icons.phone_in_talk_rounded,
                    color: Color(0xFF2A9D8F),
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // 2. Follow Button
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: onToggleFollow,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isFollowing
                        ? const Color(0xFF0F382C)
                        : const Color(0xFF2A9D8F),
                    side: BorderSide(
                      color: isFollowing
                          ? const Color(0xFF0F382C)
                          : const Color(0xFF2A9D8F),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(
                    isFollowing
                        ? Icons.check_circle_rounded
                        : Icons.add_circle_outline_rounded,
                    size: 18,
                  ),
                  label: Text(
                    isFollowing ? 'ติดตามแล้ว' : 'ติดตามร้าน',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // 3. Directions Button (Primary Action)
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: onDirections,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE76F51),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: const Color(0xFFE76F51).withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.near_me_rounded, size: 18),
                  label: const Text(
                    'ดูเส้นทาง',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
