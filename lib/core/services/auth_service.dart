import 'package:get/get.dart';

class AuthService extends GetxService {
  final isLoggedIn = false.obs;

  Future<AuthService> init() async {
    return this;
  }
}
