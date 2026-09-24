import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'manage_contents_metric_card.dart';

class ManageContentsHero extends StatelessWidget {
  const ManageContentsHero({
    super.key,
    required this.shopName,
    required this.totalContents,
    required this.totalViews,
  });

  final String? shopName;
  final int totalContents;
  final int totalViews;

  @override
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Gradient Background Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 48),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF064E3B),
                  Color(0xFF047857),
                  Color(0xFF059669),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Colors.amberAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shopName ?? 'เรื่องราวและโปรโมชั่นร้าน',
                            style: GoogleFonts.krub(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'บอกเล่าเรื่องราวสินค้า เพื่อสร้างความน่าเชื่อถือและเพิ่มยอดขาย',
                            style: GoogleFonts.krub(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
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

          // Floating Summary Cards (Overlapping)
          Positioned(
            bottom: -32,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: ManageContentsMetricCard(
                    title: 'เรื่องราวทั้งหมด',
                    value: '$totalContents บทความ',
                    icon: Icons.article_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF10B981)],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ManageContentsMetricCard(
                    title: 'การเข้าชมรวม',
                    value: '$totalViews ครั้ง',
                    icon: Icons.remove_red_eye_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
