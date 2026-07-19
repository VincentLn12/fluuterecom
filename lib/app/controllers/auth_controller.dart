import 'package:get/get.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class AuthController extends GetxController {
  final UserService userService;

  AuthController({required this.userService});

  final currentUser = Rxn<UserModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  bool get isOwner => currentUser.value?.isOwner ?? false;
  bool get isTenant => currentUser.value?.isTenant ?? false;

  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final users = await userService.getUsers();
      final user = users.firstWhereOrNull(
        (item) =>
            item.email.trim().toLowerCase() == email.trim().toLowerCase() &&
            item.password == password,
      );

      if (user == null) {
        throw 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
      }

      currentUser.value = user;
      return true;
    } catch (error) {
      errorMessage.value = error.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    currentUser.value = null;
  }
}
