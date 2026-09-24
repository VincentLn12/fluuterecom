import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/admin/models/admin_dashboard_model.dart';

class AdminDashboardTopShops extends StatelessWidget {
  const AdminDashboardTopShops({super.key, required this.topShops});

  final List<AdminTopShop> topShops;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ร้านค้ายอดขายสูงสุด',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        if (topShops.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('ไม่มีข้อมูลร้านค้า')),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topShops.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final shop = topShops[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.accent.withOpacity(0.15),
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  title: Text(
                    shop.shopName,
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'ชำระแล้ว ${shop.paidOrders} ออเดอร์',
                    style: GoogleFonts.krub(fontSize: 12),
                  ),
                  trailing: Text(
                    '฿${shop.sales.toStringAsFixed(2)}',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
