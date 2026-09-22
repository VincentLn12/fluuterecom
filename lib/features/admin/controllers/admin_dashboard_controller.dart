import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/network/api_client.dart';
import '../models/admin_dashboard_model.dart';
import '../repositories/admin_repository.dart';

class AdminDashboardController extends GetxController {
  final AdminRepository _repository = Get.find<AdminRepository>();

  final isLoading = false.obs;
  final isExporting = false.obs;
  final report = Rxn<AdminDashboardReport>();

  final selectedFromDate = ''.obs;
  final selectedToDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      final res = await _repository.fetchDashboardReport(
        from: selectedFromDate.value.isEmpty ? null : selectedFromDate.value,
        to: selectedToDate.value.isEmpty ? null : selectedToDate.value,
      );
      report.value = res;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> exportData(String type, {String format = 'csv'}) async {
    isExporting.value = true;
    try {
      final exportUrl = _repository.buildAdminExportUrl(
        exportType: type,
        fromDate: selectedFromDate.value.isEmpty ? null : selectedFromDate.value,
        toDate: selectedToDate.value.isEmpty ? null : selectedToDate.value,
        format: format,
      );

      final token = Get.find<ApiClient>().authToken;
      final uri = Uri.parse(exportUrl);
      bool launched = false;

      try {
        final browser = InAppBrowser();
        await browser.openUrlRequest(
          urlRequest: URLRequest(
            url: WebUri(exportUrl),
            headers: {
              if (token != null && token.isNotEmpty)
                'Authorization': 'Bearer $token',
            },
          ),
          settings: InAppBrowserClassSettings(
            browserSettings: InAppBrowserSettings(
              hideUrlBar: false,
            ),
          ),
        );
        launched = true;
      } catch (e) {
        debugPrint('InAppBrowser launch error: $e');
      }

      if (!launched) {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar(
            'ส่งออกรายงานสำเร็จ',
            'ดาวน์โหลดไฟล์ได้ที่: $exportUrl',
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    } catch (e) {
      debugPrint('Error exporting $type: $e');
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถส่งออกข้อมูล $type ได้', snackPosition: SnackPosition.TOP);
    } finally {
      isExporting.value = false;
    }
  }
}
