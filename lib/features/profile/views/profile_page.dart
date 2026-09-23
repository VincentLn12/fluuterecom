import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../merchant/repositories/merchant_repository.dart';

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
        title: Text(
          'บัญชีของฉัน',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            tooltip: 'การตั้งค่า',
            onPressed: () => _showSettingsModal(context, authService),
          ),
        ],
      ),
      body: Obx(() {
        final isLoggedIn = authService.isLoggedIn.value;
        final user = authService.currentUser.value;
        final isAdmin = user?.isAdmin == true;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Breadcrumb Bar (Matching Web App)
              _buildTopBreadcrumbBar(),

              const SizedBox(height: 14),

              // 2. User Mini Profile Card (Matching ProfileSidebar.vue)
              _buildUserMiniCard(context, isLoggedIn, user, authService),

              const SizedBox(height: 14),

              // 3. Section 1: บัญชีของฉัน
              _buildSectionCard(
                title: 'บัญชีของฉัน',
                icon: Icons.person_outline_rounded,
                children: [
                  _buildNavigationTile(
                    icon: Icons.badge_outlined,
                    title: 'ข้อมูลส่วนตัว',
                    subtitle: 'จัดการชื่อ อีเมล และรหัสผ่าน',
                    onTap: () {
                      if (isLoggedIn) {
                        Get.toNamed(AppRoutes.editProfile);
                      } else {
                        _showAuthRequiredDialog(context, 'ข้อมูลส่วนตัว');
                      }
                    },
                  ),
                  const Divider(
                    height: 1,
                    indent: 52,
                    color: Color(0xFFE8D9C9),
                  ),
                  _buildNavigationTile(
                    icon: Icons.location_on_outlined,
                    title: 'สมุดที่อยู่จัดส่ง',
                    subtitle: 'จัดการที่อยู่สำหรับส่งสินค้า',
                    onTap: () {
                      if (isLoggedIn) {
                        Get.snackbar(
                          'ที่อยู่จัดส่ง',
                          'จัดการที่อยู่สำหรับจัดส่งสินค้าของคุณ',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: const Color(0xFF2B1F17),
                          colorText: Colors.white,
                        );
                      } else {
                        _showAuthRequiredDialog(context, 'สมุดที่อยู่จัดส่ง');
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 4. Section 2: กิจกรรมและการใช้งาน (Activities & Usage)
              _buildSectionCard(
                title: 'กิจกรรมและการใช้งาน',
                icon: Icons.interests_outlined,
                children: [
                  _buildNavigationTile(
                    icon: Icons.article_outlined,
                    title: 'คอนเทนต์ของฉัน',
                    subtitle: 'เรื่องราวและบทความที่คุณเขียนหรือโพสต์ไว้',
                    badgeText: isLoggedIn ? 'คอนเทนต์' : null,
                    badgeColor: const Color(0xFFD96C2C),
                    onTap: () {
                      if (isLoggedIn) {
                        Get.toNamed(AppRoutes.myContents);
                      } else {
                        _showAuthRequiredDialog(context, 'คอนเทนต์ของฉัน');
                      }
                    },
                  ),
                  const Divider(
                    height: 1,
                    indent: 52,
                    color: Color(0xFFE8D9C9),
                  ),
                  _buildNavigationTile(
                    icon: Icons.favorite_border_rounded,
                    title: 'รายการโปรดที่บันทึกไว้',
                    subtitle:
                        'เรื่องราว สถานที่ท่องเที่ยว และบทความที่คุณชื่นชอบ',
                    badgeText: isLoggedIn ? 'โปรด' : null,
                    badgeColor: const Color(0xFFE76F51),
                    onTap: () {
                      if (isLoggedIn) {
                        Get.toNamed(AppRoutes.favorites);
                      } else {
                        _showAuthRequiredDialog(context, 'รายการโปรด');
                      }
                    },
                  ),
                  const Divider(
                    height: 1,
                    indent: 52,
                    color: Color(0xFFE8D9C9),
                  ),
                  _buildNavigationTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'ประวัติคำสั่งซื้อ',
                    subtitle: 'ตรวจสอบสถานะและประวัติการสั่งซื้อ',
                    badgeText: isLoggedIn ? 'ออเดอร์' : null,
                    badgeColor: const Color(0xFFD96C2C),
                    onTap: () {
                      if (isLoggedIn) {
                        Get.toNamed(AppRoutes.orders);
                      } else {
                        _showAuthRequiredDialog(context, 'ประวัติคำสั่งซื้อ');
                      }
                    },
                  ),
                  const Divider(
                    height: 1,
                    indent: 52,
                    color: Color(0xFFE8D9C9),
                  ),
                  _buildNavigationTile(
                    icon: Icons.history_rounded,
                    title: 'ประวัติการเข้าชม',
                    subtitle: 'เรื่องราวและบทความที่คุณเคยเปิดอ่าน',
                    badgeText: isLoggedIn ? 'ประวัติ' : null,
                    badgeColor: const Color(0xFFD96C2C),
                    onTap: () {
                      if (isLoggedIn) {
                        Get.toNamed(AppRoutes.history);
                      } else {
                        _showAuthRequiredDialog(context, 'ประวัติการเข้าชม');
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 5. Section 3: ศูนย์ผู้ขาย & ร้านค้า
              _buildSectionCard(
                title: 'ศูนย์ผู้ขาย & ร้านค้า',
                icon: Icons.storefront_rounded,
                children: [
                  _buildNavigationTile(
                    icon: Icons.store_mall_directory_outlined,
                    iconColor: const Color(0xFF1F5F58),
                    title: 'ศูนย์ผู้ขาย / ร้านค้าของฉัน',
                    subtitle: 'จัดการสินค้า และออเดอร์ของร้านค้า',
                    onTap: () async {
                      if (isLoggedIn) {
                        final shop = await MerchantRepository().fetchMyShop();
                        Get.toNamed(
                          shop == null
                              ? AppRoutes.registerShop
                              : AppRoutes.myShop,
                        );
                      } else {
                        _showAuthRequiredDialog(context, 'ศูนย์ผู้ขาย');
                      }
                    },
                  ),
                  if (isAdmin) ...[
                    const Divider(
                      height: 1,
                      indent: 52,
                      color: Color(0xFFE8D9C9),
                    ),
                    _buildNavigationTile(
                      icon: Icons.admin_panel_settings_outlined,
                      iconColor: const Color(0xFFC8952F),
                      title: 'จัดการแอดมิน / ระบบผู้ดูแลระบบ',
                      subtitle: 'จัดการร้านค้า สลิปการโอน หมวดหมู่ และรายงาน',
                      onTap: () {
                        Get.toNamed(AppRoutes.admin);
                      },
                    ),
                  ],
                ],
              ),

              if (isAdmin) ...[
                const SizedBox(height: 14),
                _buildSectionCard(
                  title: 'ระบบผู้ดูแลระบบ (Admin Management)',
                  icon: Icons.admin_panel_settings_rounded,
                  children: [
                    _buildNavigationTile(
                      icon: Icons.shield_outlined,
                      iconColor: const Color(0xFFC8952F),
                      title: 'จัดการแอดมิน / ควบคุมระบบ (Admin Dashboard)',
                      subtitle:
                          'เข้าสู่แดชบอร์ดผู้ดูแลระบบเพื่อจัดการ 13 ระบบย่อย',
                      onTap: () {
                        Get.toNamed(AppRoutes.admin);
                      },
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 14),

              // 6. Section 4: อื่น ๆ & ความช่วยเหลือ
              _buildSectionCard(
                title: 'อื่น ๆ & ความช่วยเหลือ',
                icon: Icons.help_outline_rounded,
                children: [
                  _buildNavigationTile(
                    icon: Icons.quiz_outlined,
                    title: 'ช่วยเหลือและคำถามที่พบบ่อย',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        'ช่วยเหลือ',
                        'หากต้องการความช่วยเหลือเพิ่มเติม ติดต่อผู้ดูแลได้ที่ support@kanchanaburi.go.th',
                      );
                    },
                  ),
                  const Divider(
                    height: 1,
                    indent: 52,
                    color: Color(0xFFE8D9C9),
                  ),
                  _buildNavigationTile(
                    icon: Icons.description_outlined,
                    title: 'ข้อกำหนดและนโยบายความเป็นส่วนตัว',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        'ข้อกำหนดและนโยบาย',
                        'แพลตฟอร์มนี้ปฏิบัติตาม พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล (PDPA) เพื่อความปลอดภัยสูงสุดของคุณ',
                      );
                    },
                  ),
                  const Divider(
                    height: 1,
                    indent: 52,
                    color: Color(0xFFE8D9C9),
                  ),
                  _buildNavigationTile(
                    icon: Icons.info_outline_rounded,
                    title: 'เกี่ยวกับแพลตฟอร์ม',
                    subtitle: 'เวอร์ชัน 1.0.0 (KRU Boat API)',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        'เกี่ยวกับ กาญจนบุรี แพลตฟอร์ม',
                        'ระบบส่งเสริมการท่องเที่ยว ชุมชน OTOP และเศรษฐกิจดิจิทัล จังหวัดกาญจนบุรี\nเวอร์ชัน 1.0.0 (KRU Boat API Integration)',
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // 7. Logout Button
              if (isLoggedIn) ...[
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutDialog(context, authService),
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: Text(
                      'ออกจากระบบ',
                      style: GoogleFonts.krub(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE53935),
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFFE53935),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Footer
              Center(
                child: Text(
                  'กาญจนบุรี แพลตฟอร์ม v1.0.0',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: const Color(0xFF786B62),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // 1. Top Breadcrumb Bar
  Widget _buildTopBreadcrumbBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'หน้าแรก',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF786B62),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Colors.grey,
              ),
              Text(
                'บัญชีของฉัน',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD96C2C),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFD96C2C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD96C2C).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 12,
                  color: Color(0xFFD96C2C),
                ),
                const SizedBox(width: 4),
                Text(
                  'ระบบจัดการบัญชี',
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD96C2C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. User Mini Profile Card
  Widget _buildUserMiniCard(
    BuildContext context,
    bool isLoggedIn,
    dynamic user,
    AuthService authService,
  ) {
    String initials = 'G';
    if (isLoggedIn &&
        user != null &&
        user.displayName != null &&
        user.displayName.isNotEmpty) {
      final parts = user.displayName.trim().split(' ');
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = user.displayName.substring(0, 1).toUpperCase();
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Initials Gradient Avatar
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isLoggedIn
                        ? [
                            const Color(0xFFD96C2C),
                            const Color(0xFFBF5720),
                            const Color(0xFF171412),
                          ]
                        : [Colors.grey[400]!, Colors.grey[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD96C2C).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isLoggedIn ? initials : 'G',
                    style: GoogleFonts.krub(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (isLoggedIn)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 14),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoggedIn && user != null) ...[
                  Text(
                    user.displayName ?? 'สมาชิกกาญจนบุรี',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF332820),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.krub(
                      fontSize: 12.5,
                      color: const Color(0xFF786B62),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD96C2C).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      (user.role?.toLowerCase() == 'admin' ||
                              user.role?.toLowerCase() == 'administrator')
                          ? '👑 ผู้ดูแลระบบ'
                          : '⭐ สมาชิกกาญจนบุรี',
                      style: GoogleFonts.krub(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD96C2C),
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    'ยังไม่ได้เข้าสู่ระบบ',
                    style: GoogleFonts.krub(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF332820),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'เข้าสู่ระบบเพื่อใช้งานฟีเจอร์เต็มรูปแบบ',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: const Color(0xFF786B62),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.login),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD96C2C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'เข้าสู่ระบบ / สมัครสมาชิก',
                        style: GoogleFonts.krub(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Card
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFFD96C2C)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF332820),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          ...children,
        ],
      ),
    );
  }

  // Navigation ListTile
  Widget _buildNavigationTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    String? subtitle,
    String? badgeText,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Icon(
          icon,
          color: iconColor ?? const Color(0xFFD96C2C),
          size: 22,
        ),
        title: Text(
          title,
          style: GoogleFonts.krub(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF332820),
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.krub(
                  fontSize: 11.5,
                  color: const Color(0xFF786B62),
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeText != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? const Color(0xFFD96C2C)).withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor ?? const Color(0xFFD96C2C),
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showAuthRequiredDialog(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            const Icon(Icons.lock_rounded, color: Color(0xFFD96C2C)),
            const SizedBox(width: 8),
            Text(
              'ต้องเข้าสู่ระบบ',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'กรุณาเข้าสู่ระบบเพื่อใช้งานส่วน "$featureName"',
          style: GoogleFonts.krub(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.krub(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.toNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD96C2C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'เข้าสู่ระบบ',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          title,
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          content,
          style: GoogleFonts.krub(fontSize: 14, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD96C2C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'ตกลง',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsModal(BuildContext context, AuthService authService) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'การตั้งค่าทั่วไป',
              style: GoogleFonts.krub(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.language_rounded,
                color: Color(0xFFD96C2C),
              ),
              title: Text('ภาษา / Language', style: GoogleFonts.krub()),
              subtitle: Text(
                'ภาษาไทย (TH)',
                style: GoogleFonts.krub(fontSize: 12),
              ),
              onTap: () => Navigator.pop(context),
            ),
            if (authService.currentUser.value?.isAdmin == true)
              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Color(0xFFC8952F),
                ),
                title: Text(
                  'จัดการแอดมิน (Admin Dashboard)',
                  style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'เข้าสู่แดชบอร์ดผู้ดูแลระบบ (13 ระบบ)',
                  style: GoogleFonts.krub(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.admin);
                },
              ),
            ListTile(
              leading: const Icon(
                Icons.dark_mode_outlined,
                color: Color(0xFFD96C2C),
              ),
              title: Text('โหมดการแสดงผล', style: GoogleFonts.krub()),
              subtitle: Text(
                'โหมดสว่าง (Light Theme)',
                style: GoogleFonts.krub(fontSize: 12),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
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
            child: Text(
              'ยกเลิก',
              style: GoogleFonts.krub(color: Colors.grey[700]),
            ),
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
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'ออกจากระบบ',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
