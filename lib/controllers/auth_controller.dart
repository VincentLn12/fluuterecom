import 'package:get/get.dart';

import '../models/app_user.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

class AuthController extends GetxController {
  AuthController({RecipeService? service})
    : _service = service ?? RecipeService();

  final RecipeService _service;
  final users = <AppUser>[].obs;
  final currentUser = Rxn<AppUser>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  bool get isLoggedIn => currentUser.value != null;
  bool get isAdmin => currentUser.value?.isAdmin ?? false;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _service.fetchUsers();
      users.assignAll(result);
    } catch (error) {
      errorMessage.value = error.toString();
      users.assignAll(_fallbackUsers);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    if (users.isEmpty) {
      await fetchUsers();
    }
    final normalizedEmail = email.trim().toLowerCase();
    final user = users.firstWhereOrNull(
      (item) =>
          item.email.toLowerCase() == normalizedEmail &&
          item.password == password,
    );
    if (user == null) {
      Get.snackbar('เข้าสู่ระบบไม่สำเร็จ', 'อีเมลหรือรหัสผ่านไม่ถูกต้อง');
      return false;
    }
    currentUser.value = user;
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (users.any(
      (item) => item.email.toLowerCase() == email.trim().toLowerCase(),
    )) {
      Get.snackbar('สมัครสมาชิกไม่สำเร็จ', 'อีเมลนี้ถูกใช้งานแล้ว');
      return false;
    }
    try {
      isLoading.value = true;
      final created = await _service.registerUser(
        AppUser(
          id: null,
          name: name.trim(),
          email: email.trim(),
          password: password,
          role: UserRole.user,
          favoriteRecipeIds: const [],
        ),
      );
      users.add(created);
      currentUser.value = created;
      return true;
    } catch (error) {
      Get.snackbar('เกิดข้อผิดพลาด', error.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void switchUser(AppUser user) {
    currentUser.value = user;
  }

  void updateCurrentUser(AppUser user) {
    currentUser.value = user;
    final index = users.indexWhere((item) => item.id == user.id);
    if (index == -1) {
      users.add(user);
    } else {
      users[index] = user;
    }
  }

  void logout() {
    currentUser.value = null;
  }

  bool canManageRecipe(Recipe recipe) {
    final user = currentUser.value;
    if (user == null) {
      return false;
    }
    return user.isAdmin || recipe.ownerId == user.id;
  }

  List<AppUser> get _fallbackUsers {
    return const [
      AppUser(
        id: 'user-1',
        name: 'นักศึกษา Flutter',
        email: 'student@example.com',
        password: '123456',
        role: UserRole.user,
        favoriteRecipeIds: [1, 3],
      ),
      AppUser(
        id: 'user-2',
        name: 'ผู้ใช้ตัวอย่าง',
        email: 'cook@example.com',
        password: '123456',
        role: UserRole.user,
        favoriteRecipeIds: [2],
      ),
      AppUser(
        id: 'admin-1',
        name: 'ผู้ดูแลระบบ',
        email: 'admin@example.com',
        password: 'admin123',
        role: UserRole.admin,
        favoriteRecipeIds: [],
      ),
    ];
  }
}
