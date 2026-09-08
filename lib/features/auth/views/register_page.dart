import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2B1F17),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F5F58).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 42,
                      color: Color(0xFF1F5F58),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'สร้างบัญชีสมาชิกใหม่',
                  style: GoogleFonts.krub(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2B1F17),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'เริ่มต้นใช้งานแพลตฟอร์มจังหวัดกาญจนบุรี',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Form Container Card
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'อีเมลของคุณ',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B1F17),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: controller.emailController,
                      hintText: 'example@email.com',
                      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF1F5F58)),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),

                    Text(
                      'รหัสผ่าน',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B1F17),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => AppTextField(
                          controller: controller.passwordController,
                          hintText: 'กรอกรหัสผ่าน',
                          obscureText: controller.obscurePassword.value,
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF1F5F58)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: controller.toggleObscurePassword,
                          ),
                        )),
                    const SizedBox(height: 18),

                    Text(
                      'ยืนยันรหัสผ่าน',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B1F17),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => AppTextField(
                          controller: controller.confirmPasswordController,
                          hintText: 'กรอกรหัสผ่านอีกครั้ง',
                          obscureText: controller.obscureConfirmPassword.value,
                          prefixIcon: const Icon(Icons.lock_reset_rounded, color: Color(0xFF1F5F58)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscureConfirmPassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey[600],
                            ),
                            onPressed: controller.toggleObscureConfirmPassword,
                          ),
                        )),
                    const SizedBox(height: 28),

                    // Submit Button
                    Obx(() => AppButton(
                          text: 'สมัครสมาชิก',
                          isLoading: controller.isLoading.value,
                          onPressed: controller.register,
                          color: const Color(0xFF1F5F58),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Login CTA Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'มีบัญชีสมาชิกอยู่แล้ว? ',
                    style: GoogleFonts.krub(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offNamed(AppRoutes.login);
                    },
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: GoogleFonts.krub(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F5F58),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
