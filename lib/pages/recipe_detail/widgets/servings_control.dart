import 'package:flutter/material.dart';

class ServingsControl extends StatelessWidget {
  const ServingsControl({
    super.key,
    required this.servings,
    required this.baseServings,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int servings;
  final int baseServings;
  final VoidCallback? onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3EA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFD8BF)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD8BF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.groups_rounded, color: Color(0xFFE85D24)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ปรับจำนวนเสิร์ฟ\nสูตรต้นฉบับ $baseServings คน',
              style: const TextStyle(
                color: Color(0xFF8A3A18),
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
          IconButton(
            tooltip: 'ลดจำนวนเสิร์ฟ',
            onPressed: onDecrease,
            color: const Color(0xFFE85D24),
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
          SizedBox(
            width: 34,
            child: Text(
              '$servings',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF24160F),
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            tooltip: 'เพิ่มจำนวนเสิร์ฟ',
            onPressed: onIncrease,
            color: const Color(0xFFE85D24),
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
    );
  }
}
