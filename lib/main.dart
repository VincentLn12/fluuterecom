import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/config/app_config.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KanchanaburiApp());
}

class KanchanaburiApp extends StatelessWidget {
  const KanchanaburiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.initial,
      getPages: AppPages.routes,
    );
  }
}
