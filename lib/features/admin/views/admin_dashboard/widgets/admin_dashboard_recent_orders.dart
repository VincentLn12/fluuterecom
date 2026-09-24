import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/admin/models/admin_dashboard_model.dart';

class AdminDashboardRecentOrders extends StatelessWidget {
  const AdminDashboardRecentOrders({super.key, required this.recentOrders});

  final List<AdminRecentOrder> recentOrders;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'คำสั่งซื้อล่าสุด',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.adminOrders),
              child: Text(
                'ดูทั้งหมด',
                style: GoogleFonts.krub(color: AppColors.primary, fontSize: 13),
              ),
            ),
          ],
        ),
        if (recentOrders.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('ไม่มีคำสั่งซื้อล่าสุด')),
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
              itemCount: recentOrders.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final order = recentOrders[index];
                return ListTile(
                  title: Text(
                    '#${order.orderNumber} - ${order.shopName}',
                    style: GoogleFonts.krub(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    'ยอดรวม: ฿${order.totalAmount.toStringAsFixed(2)} | สถานะ: ${order.orderStatus}',
                    style: GoogleFonts.krub(fontSize: 11),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.paymentStatus,
                      style: GoogleFonts.krub(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
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
