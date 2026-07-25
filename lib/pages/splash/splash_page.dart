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
      Get.offNamed(AppRoutes.auth);
    });
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
                    style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800),
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
