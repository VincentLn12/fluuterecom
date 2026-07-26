import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/app_user.dart';
import '../models/recipe.dart';
import '../utils/constants.dart';

class RecipeService {
  RecipeService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 10);

  String get _baseUrl {
    if (Platform.isAndroid) {
      return AppConstants.androidBaseUrl;
    }
    return AppConstants.localBaseUrl;
  }

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<List<Recipe>> fetchRecipes() async {
    final response = await _client.get(_uri('/recipes')).timeout(_timeout);
    _checkResponse(response, 'โหลดสูตรอาหารไม่สำเร็จ');
    final items = jsonDecode(response.body) as List<dynamic>;
    return items
        .whereType<Map<String, Object?>>()
        .map(Recipe.fromJson)
        .toList();
  }

  Future<Recipe> fetchRecipe(int id) async {
    final response = await _client.get(_uri('/recipes/$id')).timeout(_timeout);
    _checkResponse(response, 'โหลดรายละเอียดสูตรอาหารไม่สำเร็จ');
    return Recipe.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<List<Category>> fetchCategories() async {
    final response = await _client.get(_uri('/categories')).timeout(_timeout);
    _checkResponse(response, 'โหลดหมวดหมู่ไม่สำเร็จ');
    final items = jsonDecode(response.body) as List<dynamic>;
    return items
        .whereType<Map<String, Object?>>()
        .map(Category.fromJson)
        .toList();
  }

  Future<List<AppUser>> fetchUsers() async {
    final response = await _client.get(_uri('/users')).timeout(_timeout);
    _checkResponse(response, 'โหลดบัญชีผู้ใช้ไม่สำเร็จ');
    final items = jsonDecode(response.body) as List<dynamic>;
    return items
        .whereType<Map<String, Object?>>()
        .map(AppUser.fromJson)
        .toList();
  }

  Future<AppUser> registerUser(AppUser user) async {
    final response = await _client
        .post(
          _uri('/users'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(user.toJson()..remove('id')),
        )
        .timeout(_timeout);
    _checkResponse(response, 'สมัครสมาชิกไม่สำเร็จ', successCode: 201);
    return AppUser.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<AppUser> updateUser(AppUser user) async {
    if (user.id == null) {
      throw Exception('ไม่พบรหัสผู้ใช้สำหรับแก้ไข');
    }
    final response = await _client
        .put(
          _uri('/users/${user.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(user.toJson()),
        )
        .timeout(_timeout);
    _checkResponse(response, 'บันทึกรายการโปรดไม่สำเร็จ');
    return AppUser.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<Recipe> addRecipe(Recipe recipe) async {
    final response = await _client
        .post(
          _uri('/recipes'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(recipe.toJson()..remove('id')),
        )
        .timeout(_timeout);
    _checkResponse(response, 'เพิ่มสูตรอาหารไม่สำเร็จ', successCode: 201);
    return Recipe.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<Recipe> updateRecipe(Recipe recipe) async {
    if (recipe.id == null) {
      throw Exception('ไม่พบรหัสสูตรอาหารสำหรับแก้ไข');
    }
    var response = await _putRecipe(recipe.id.toString(), recipe);
    if (response.statusCode == 404) {
      final serverId = await _findServerRecipeId(recipe.id.toString());
      if (serverId != null) {
        response = await _putRecipe(serverId, recipe);
      }
    }
    _checkResponse(response, 'แก้ไขสูตรอาหารไม่สำเร็จ');
    return Recipe.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<void> deleteRecipe(int id) async {
    var response = await _client.delete(_uri('/recipes/$id')).timeout(_timeout);
    if (response.statusCode == 404) {
      final serverId = await _findServerRecipeId(id.toString());
      if (serverId != null) {
        response = await _client
            .delete(_uri('/recipes/$serverId'))
            .timeout(_timeout);
      }
    }
    _checkResponse(response, 'ลบสูตรอาหารไม่สำเร็จ');
  }

  Future<http.Response> _putRecipe(String id, Recipe recipe) {
    return _client
        .put(
          _uri('/recipes/$id'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(recipe.toJson()),
        )
        .timeout(_timeout);
  }

  Future<String?> _findServerRecipeId(String id) async {
    final response = await _client
        .get(_uri('/recipes?id=$id'))
        .timeout(_timeout);
    if (response.statusCode != 200) {
      return null;
    }
    final items = jsonDecode(response.body) as List<dynamic>;
    if (items.isEmpty) {
      return null;
    }
    final item = items.first as Map<String, Object?>;
    return item['id']?.toString();
  }

  void _checkResponse(
    http.Response response,
    String message, {
    int successCode = 200,
  }) {
    if (response.statusCode != successCode) {
      throw Exception('$message (${response.statusCode})');
    }
  }
}
