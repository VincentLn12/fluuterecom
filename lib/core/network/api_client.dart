import 'package:get/get.dart';
import '../../app/config/api_config.dart';

class ApiClient extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConfig.baseUrl;
    httpClient.timeout = ApiConfig.connectTimeout;
    super.onInit();
  }
}
