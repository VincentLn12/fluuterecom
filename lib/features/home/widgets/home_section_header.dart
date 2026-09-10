import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  static const Color brandPrimary = Color(0xFFC85A17);
  static const Color textBlack = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF334155);

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 5,
              height: 22,
              decoration: BoxDecoration(
                color: brandPrimary,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: textBlack,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildPlaceholderBox() {
  return Container(
    color: const Color(0xFFE2E8F0),
    child: const Center(
      child: Icon(Icons.image_outlined, color: Color(0xFF334155), size: 28),
    ),
  );
}

Widget buildGradientBannerBg() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFC85A17), Color(0xFFE65100)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: const Center(
      child: Icon(Icons.landscape_rounded, color: Colors.white, size: 48),
    ),
  );
}
