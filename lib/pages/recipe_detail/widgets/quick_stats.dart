import 'package:flutter/material.dart';
import '../../../models/recipe.dart';

class QuickStats extends StatelessWidget {
  const QuickStats({super.key, required this.recipe, required this.servings});

  final Recipe recipe;
  final int servings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFDEC8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE85D24).withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: StatPill(
              icon: Icons.schedule_rounded,
              label: 'เวลา',
              value: '${recipe.totalTime} นาที',
            ),
          ),
          const StatDivider(),
          Expanded(
            child: StatPill(
              icon: Icons.restaurant_rounded,
              label: 'เสิร์ฟ',
              value: '$servings คน',
            ),
          ),
          const StatDivider(),
          Expanded(
            child: StatPill(
              icon: Icons.local_fire_department_rounded,
              label: 'ระดับ',
              value: recipe.difficulty.isEmpty ? 'ไม่ระบุ' : recipe.difficulty,
            ),
          ),
        ],
      ),
    );
  }
}

class StatPill extends StatelessWidget {
  const StatPill({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFE85D24), size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF24160F),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF8C7465),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class StatDivider extends StatelessWidget {
  const StatDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0xFFFFE4D3),
    );
  }
}
