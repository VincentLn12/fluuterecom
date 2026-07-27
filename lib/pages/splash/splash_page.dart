import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../utils/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      Get.offNamed(AppRoutes.home);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // โหลด Asset รูปภาพล่วงหน้า (Pre-cache) ห่อด้วย try-catch เพื่อป้องกันแอปแครชหาก Asset นั้นยังไม่ได้บันเดิลใน Build ปัจจุบัน
    try {
      precacheImage(const AssetImage(AppConstants.logoAsset), context);
      precacheImage(const AssetImage(AppConstants.placeholderFoodAsset), context);
      precacheImage(const AssetImage(AppConstants.defaultProfileAsset), context);
    } catch (e) {
      // ข้ามหากไม่พบไฟล์หรือยังไม่ได้สั่ง Rebuild แอป
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(28.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppConstants.logoAsset,
                    width: 96.w,
                    height: 96.w,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.restaurant_menu,
                        size: 80.sp,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text( 
                    AppConstants.appTagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
