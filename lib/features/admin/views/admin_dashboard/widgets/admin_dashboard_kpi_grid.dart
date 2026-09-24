import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/admin/models/admin_dashboard_model.dart';

class AdminDashboardKpiGrid extends StatelessWidget {
  const AdminDashboardKpiGrid({super.key, this.summary});

  final AdminDashboardSummary? summary;

  @override
  Widget build(BuildContext context) {
    final totalSales = summary?.totalSales ?? 0.0;
    final totalOrders = summary?.totalOrders ?? 0;
    final paidOrders = summary?.paidOrders ?? 0;
    final pendingPayout = summary?.pendingPayoutAmount ?? 0.0;
    final activeShops = summary?.activeShops ?? 0;
    final lowStock = summary?.lowStockProducts ?? 0;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildKpiCard(
          title: 'ยอดขายรวม',
          value: '฿${totalSales.toStringAsFixed(2)}',
          icon: Icons.monetization_on_outlined,
          color: const Color(0xFF1B4D3E),
        ),
        _buildKpiCard(
          title: 'ออเดอร์ทั้งหมด',
          value: '$totalOrders รายการ',
          subtitle: 'ชำระแล้ว $paidOrders รายการ',
          icon: Icons.shopping_bag_outlined,
          color: const Color(0xFF2A9D8F),
        ),
        _buildKpiCard(
          title: 'ยอดรอโอนร้านค้า',
          value: '฿${pendingPayout.toStringAsFixed(2)}',
          icon: Icons.account_balance_outlined,
          color: AppColors.accent,
        ),
        _buildKpiCard(
          title: 'ร้านค้าที่เปิดใช้งาน',
          value: '$activeShops ร้าน',
          subtitle: lowStock > 0 ? 'สินค้าสต็อกต่ำ $lowStock รายการ' : null,
          icon: Icons.storefront_outlined,
          color: const Color(0xFF457B9D),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.krub(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }
}
