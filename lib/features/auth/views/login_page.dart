import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

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
              const SizedBox(height: 20),
              // App Logo / Header Banner
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B1F17),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF332820).withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.storefront_rounded,
                      size: 48,
                      color: Color(0xFFD96C2C),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'เข้าสู่ระบบ',
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
                  'เข้าสู่ระบบ แพลตฟอร์มท่องเที่ยวและสินค้าเมืองกาญจน์',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Form Container Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFEADCCF),
                    width: 1.2,
                  ),
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
                      hintText: 'test@email.com',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFFD96C2C),
                      ),
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
                    Obx(
                      () => AppTextField(
                        controller: controller.passwordController,
                        hintText: 'กรอกรหัสผ่าน',
                        obscureText: controller.obscurePassword.value,
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: Color(0xFFD96C2C),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[600],
                          ),
                          onPressed: controller.toggleObscurePassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Submit Button
                    Obx(
                      () => AppButton(
                        text: 'เข้าสู่ระบบ',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.login,
                        color: const Color(0xFFD96C2C),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Register CTA Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ยังไม่มีบัญชีสมาชิก? ',
                    style: GoogleFonts.krub(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.register);
                    },
                    child: Text(
                      'สมัครสมาชิก',
                      style: GoogleFonts.krub(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD96C2C),
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
