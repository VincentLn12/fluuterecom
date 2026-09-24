import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/app/theme/app_colors.dart';

class AdminDashboardQuickAccessHub extends StatelessWidget {
  const AdminDashboardQuickAccessHub({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickItem(
        '1. รายงานผู้บริหาร',
        Icons.analytics_outlined,
        AppColors.primary,
        () => Get.toNamed(AppRoutes.adminExports),
      ),
      _QuickItem(
        '2. ตรวจสอบสลิป',
        Icons.fact_check_outlined,
        AppColors.accent,
        () => Get.toNamed(AppRoutes.adminOrders),
      ),
      _QuickItem(
        '3. โอนเงินร้านค้า',
        Icons.price_check_outlined,
        const Color(0xFF2A9D8F),
        () => Get.toNamed(AppRoutes.adminPayouts),
      ),
      _QuickItem(
        '4. จัดการร้านค้า',
        Icons.store_outlined,
        const Color(0xFF457B9D),
        () => Get.toNamed(AppRoutes.adminShops),
      ),
      _QuickItem(
        '5. จัดการหมวดหมู่',
        Icons.category_outlined,
        const Color(0xFFE9C46A),
        () => Get.toNamed(AppRoutes.adminCategories),
      ),
      _QuickItem(
        '6. จัดการเนื้อหา',
        Icons.article_outlined,
        const Color(0xFF6B705C),
        () => Get.toNamed(AppRoutes.adminContents),
      ),
      _QuickItem(
        '7. จัดการแท็ก',
        Icons.label_outlined,
        const Color(0xFF8338EC),
        () => Get.toNamed(AppRoutes.adminTags),
      ),
      _QuickItem(
        '8. ตารางกิจกรรม',
        Icons.event_outlined,
        const Color(0xFF3A86EF),
        () => Get.toNamed(AppRoutes.adminSchedules),
      ),
      _QuickItem(
        '9. รายงานร้องเรียน',
        Icons.report_problem_outlined,
        AppColors.error,
        () => Get.toNamed(AppRoutes.adminReports),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.color, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickItem(this.title, this.icon, this.color, this.onTap);
}
