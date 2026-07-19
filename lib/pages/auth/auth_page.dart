import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../main/main_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(text: 'student@example.com');
  final _passwordController = TextEditingController(text: '123456');
  bool _isRegisterMode = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 460.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 42.r,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 42.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      AppConstants.appName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _isRegisterMode ? 'สมัครสมาชิกเพื่อสร้างสูตรของคุณ' : 'เข้าสู่ระบบเพื่อจัดการสูตรอาหาร',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('ล็อกอิน'), icon: Icon(Icons.login)),
                        ButtonSegment(value: true, label: Text('สมัครสมาชิก'), icon: Icon(Icons.person_add)),
                      ],
                      selected: {_isRegisterMode},
                      onSelectionChanged: (value) {
                        setState(() => _isRegisterMode = value.first);
                      },
                    ),
                    SizedBox(height: 18.h),
                    if (_isRegisterMode) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'ชื่อผู้ใช้',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (!_isRegisterMode) {
                            return null;
                          }
                          if (value == null || value.trim().isEmpty) {
                            return 'ชื่อผู้ใช้ห้ามว่าง';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12.h),
                    ],
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'อีเมล',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'อีเมลห้ามว่าง';
                        }
                        if (!value.contains('@')) {
                          return 'รูปแบบอีเมลไม่ถูกต้อง';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 18.h),
                    Obx(
                      () => ElevatedButton(
                        onPressed: authController.isLoading.value ? null : _submit,
                        child: authController.isLoading.value
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(_isRegisterMode ? 'สมัครสมาชิก' : 'เข้าสู่ระบบ'),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      'เข้าแบบไว',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _quickLogin(UserRole.user),
                            icon: const Icon(Icons.person),
                            label: const Text('สมาชิก'),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _quickLogin(UserRole.admin),
                            icon: const Icon(Icons.admin_panel_settings),
                            label: const Text('แอดมิน'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Obx(() {
                      if (authController.errorMessage.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        authController.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12.sp,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final authController = Get.find<AuthController>();
    final success = _isRegisterMode
        ? await authController.register(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          )
        : await authController.login(
            email: _emailController.text,
            password: _passwordController.text,
          );
    if (success && mounted) {
      _openMainPage();
    }
  }

  Future<void> _quickLogin(UserRole role) async {
    final authController = Get.find<AuthController>();
    if (authController.users.isEmpty) {
      await authController.fetchUsers();
    }
    final user = authController.users.firstWhereOrNull((item) => item.role == role);
    if (user == null) {
      Get.snackbar('ไม่พบบัญชี', 'กรุณาเปิด json-server แล้วลองใหม่');
      return;
    }
    authController.switchUser(user);
    if (mounted) {
      _openMainPage();
    }
  }

  void _openMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const MainPage()),
    );
  }
}
