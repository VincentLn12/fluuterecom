import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopLinkBanner extends StatelessWidget {
  const ShopLinkBanner({super.key, required this.shopName});

  final String shopName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFEDD5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.storefront_rounded,
            color: Color(0xFFD96C2C),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ผูกกับร้านค้าอัตโนมัติ',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'เรื่องราวนี้จะถูกเชื่อมกับร้าน "$shopName" และแสดงผลต่อสาธารณะ',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: const Color(0xFF786B62),
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
