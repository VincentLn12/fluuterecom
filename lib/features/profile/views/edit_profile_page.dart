import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/auth_service.dart';
import '../controllers/profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final authService = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'แก้ไขข้อมูลส่วนตัว',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          children: [
            // Avatar Header Card
            Obx(() {
              final user = authService.currentUser.value;
              String initials = 'U';
              if (user != null && user.displayName.isNotEmpty) {
                final parts = user.displayName.trim().split(' ');
                if (parts.length >= 2) {
                  initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
                } else {
                  initials = user.displayName.substring(0, 1).toUpperCase();
                }
              }

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE8D9C9),
                    width: 1.3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFD96C2C),
                                Color(0xFFBF5720),
                                Color(0xFF171412),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFD96C2C,
                                ).withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: GoogleFonts.krub(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD96C2C),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.displayName ?? 'ผู้ใช้งาน',
                      style: GoogleFonts.krub(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF332820),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user?.email ?? '-',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        color: const Color(0xFF786B62),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // Form Edit Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.edit_note_rounded,
                        color: Color(0xFFD96C2C),
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ข้อมูลส่วนตัว',
                        style: GoogleFonts.krub(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF332820),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Color(0xFFE8D9C9)),

                  // First Name Input
                  Text(
                    'ชื่อจริง *',
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF332820),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controller.firstNameController,
                    style: GoogleFonts.krub(
                      fontSize: 14.5,
                      color: const Color(0xFF332820),
                    ),
                    decoration: InputDecoration(
                      hintText: 'กรอกชื่อจริง',
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFFD96C2C),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8D9C9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8D9C9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFD96C2C),
                          width: 1.8,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Last Name Input
                  Text(
                    'นามสกุล',
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF332820),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controller.lastNameController,
                    style: GoogleFonts.krub(
                      fontSize: 14.5,
                      color: const Color(0xFF332820),
                    ),
                    decoration: InputDecoration(
                      hintText: 'กรอกนามสกุล',
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFFD96C2C),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8D9C9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8D9C9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFD96C2C),
                          width: 1.8,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Read-Only Email Input
                  Text(
                    'อีเมล (ไม่สามารถแก้ไขได้)',
                    style: GoogleFonts.krub(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controller.emailController,
                    readOnly: true,
                    style: GoogleFonts.krub(
                      fontSize: 14.5,
                      color: Colors.grey[600],
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                      ),
                      suffixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.grey,
                        size: 18,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF4F6F5),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8D9C9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE8D9C9)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Save & Cancel Buttons
            Obx(() {
              final loading = controller.isLoading.value;

              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: loading
                          ? null
                          : () => controller.saveProfile(),
                      icon: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.2,
                              ),
                            )
                          : const Icon(Icons.save_rounded, size: 20),
                      label: Text(
                        loading ? 'กำลังบันทึก...' : 'บันทึกการเปลี่ยนแปลง',
                        style: GoogleFonts.krub(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD96C2C),
                        foregroundColor: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF786B62),
                      ),
                      child: Text(
                        'ยกเลิก',
                        style: GoogleFonts.krub(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
