import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../navigation/controllers/navigation_controller.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleObscureConfirmPassword() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar(
        'ข้อมูลไม่ถูกต้อง',
        'กรุณากรอกอีเมลให้ถูกต้อง',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        'ข้อมูลไม่ถูกต้อง',
        'กรุณากรอกรหัสผ่าน',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;
    try {
      final tokenData = await _repository.login(email, password);
      if (tokenData != null && tokenData.containsKey('accessToken')) {
        final accessToken = tokenData['accessToken'].toString();

        _authService.token.value = accessToken;
        final userProfile =
            await _repository.fetchProfile() ??
            await _repository.fetchCurrentUser() ??
            UserModel(id: '1', email: email, name: email.split('@').first);
        _authService.setSession(accessToken, userProfile);

        Get.snackbar(
          'เข้าสู่ระบบสำเร็จ',
          'ยินดีต้อนรับเข้าสู่ระบบ กาญจนบุรี แพลตฟอร์ม',
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        if (Get.isRegistered<NavigationController>()) {
          Get.find<NavigationController>().selectedIndex.value = 0;
        }

        Get.offAllNamed(AppRoutes.initial);
      } else {
        Get.snackbar(
          'เข้าสู่ระบบไม่สำเร็จ',
          'อีเมลหรือรหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง',
          backgroundColor: const Color(0xFFC62828),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar(
        'ข้อมูลไม่ถูกต้อง',
        'กรุณากรอกอีเมลให้ถูกต้อง',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        'ข้อมูลไม่ถูกต้อง',
        'กรุณากรอกรหัสผ่าน',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'ข้อมูลไม่ถูกต้อง',
        'รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน',
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;
    try {
      final success = await _repository.register(email, password);
      if (success) {
        Get.snackbar(
          'สมัครสมาชิกสำเร็จ',
          'สมัครสมาชิกเรียบร้อยแล้ว กำลังเข้าสู่ระบบ...',
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Auto login after successful registration
        await login();
      } else {
        Get.snackbar(
          'สมัครสมาชิกไม่สำเร็จ',
          'ไม่สามารถสมัครสมาชิกได้ อีเมลนี้อาจถูกใช้งานแล้ว',
          backgroundColor: const Color(0xFFC62828),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
