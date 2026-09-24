import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminExportHeroHeader extends StatelessWidget {
  const AdminExportHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2D25), Color(0xFF1B4D3E), Color(0xFF2A9D8F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Colors.amberAccent,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ศูนย์ดาวน์โหลดรายงานสำหรับแอดมิน',
                  style: GoogleFonts.krub(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ส่งออกรายงานยอดขาย รายการออเดอร์ ประวัติโอนเงิน และผลตรวจสลิป เป็นไฟล์ PDF หรือ CSV ได้ทันที',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.88),
                    height: 1.35,
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
