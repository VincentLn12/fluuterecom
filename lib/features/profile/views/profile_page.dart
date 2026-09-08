import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/status_badge.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.person_pin_rounded, color: Color(0xFFD96C2C), size: 22),
            const SizedBox(width: 8),
            Text(
              'โปรไฟล์ผู้ใช้งาน',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        final isLoggedIn = authService.isLoggedIn.value;
        final user = authService.currentUser.value;

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // User Header Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF332820).withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: isLoggedIn ? const Color(0xFFD96C2C) : Colors.grey[400],
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2B1F17), width: 2),
                    ),
                    child: Center(
                      child: Icon(
                        isLoggedIn ? Icons.person_rounded : Icons.person_outline_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (isLoggedIn && user != null) ...[
                    Text(
                      user.displayName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.krub(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B1F17),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    StatusBadge(
                      label: user.role ?? 'สมาชิกทั่วไป',
                      backgroundColor: const Color(0xFF1F5F58),
                      icon: Icons.verified_user_rounded,
                    ),
                  ] else ...[
                    Text(
                      'ยังไม่ได้เข้าสู่ระบบ',
                      style: GoogleFonts.krub(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B1F17),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'เข้าสู่ระบบเพื่อสั่งซื้อสินค้า ติดตามคำสั่งซื้อ และจัดการร้านค้า',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(AppRoutes.login);
                      },
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: Text(
                        'เข้าสู่ระบบ / สมัครสมาชิก',
                        style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD96C2C),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEADCCF), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF332820).withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.receipt_long_rounded,
                    iconColor: const Color(0xFFD96C2C),
                    title: 'ประวัติคำสั่งซื้อของฉัน',
                    subtitle: 'ดูสถานะและประวัติการสั่งซื้อสินค้า',
                    onTap: () {
                      Get.toNamed(AppRoutes.orders);
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: Color(0xFFF0E6DC)),

                  _buildMenuItem(
                    icon: Icons.storefront_rounded,
                    iconColor: const Color(0xFF1F5F58),
                    title: 'ศูนย์ผู้ขาย / ร้านค้าของฉัน',
                    subtitle: 'จัดการสินค้า และรายการสั่งซื้อของร้าน',
                    onTap: () {
                      Get.toNamed(AppRoutes.myShop);
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: Color(0xFFF0E6DC)),

                  if (isLoggedIn && (user?.role == 'Admin' || user?.role == 'Administrator')) ...[
                    _buildMenuItem(
                      icon: Icons.admin_panel_settings_rounded,
                      iconColor: const Color(0xFFC8952F),
                      title: 'ระบบผู้ดูแลระบบ (Admin Dashboard)',
                      subtitle: 'จัดการร้านค้า หมวดหมู่ และรายงาน',
                      onTap: () {
                        Get.toNamed(AppRoutes.admin);
                      },
                    ),
                    const Divider(height: 1, indent: 56, color: Color(0xFFF0E6DC)),
                  ],

                  _buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF2B1F17),
                    title: 'เกี่ยวกับ กาญจนบุรี แพลตฟอร์ม',
                    subtitle: 'เวอร์ชัน 1.0.0 (KRU Boat API)',
                    onTap: () {
                      Get.snackbar(
                        'กาญจนบุรี แพลตฟอร์ม',
                        'ระบบส่งเสริมการท่องเที่ยวและสินค้าชุมชนจังหวัดกาญจนบุรี',
                        backgroundColor: const Color(0xFF2B1F17),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                  ),
                ],
              ),
            ),

            if (isLoggedIn) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context, authService);
                },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: Text(
                  'ออกจากระบบ',
                  style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFC62828),
                  side: const BorderSide(color: Color(0xFFC62828), width: 1.5),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.krub(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2B1F17),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.krub(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'ยืนยันการออกจากระบบ',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'คุณต้องการออกจากระบบใช่หรือไม่?',
          style: GoogleFonts.krub(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey[700])),
          ),
          ElevatedButton(
            onPressed: () {
              authService.logout();
              Get.back();
              Get.snackbar(
                'ออกจากระบบแล้ว',
                'คุณได้ออกจากระบบเรียบร้อยแล้ว',
                backgroundColor: const Color(0xFF2B1F17),
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('ออกจากระบบ', style: GoogleFonts.krub(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
