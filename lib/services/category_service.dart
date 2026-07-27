import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../utils/constants.dart';

class CategoryService {
  CategoryService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 10);

  String get _baseUrl {
    if (Platform.isAndroid) {
      return AppConstants.androidBaseUrl;
    }
    return AppConstants.localBaseUrl;
  }

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<List<Category>> fetchCategories() async {
    final response = await _client.get(_uri('/categories')).timeout(_timeout);
    _checkResponse(response, 'โหลดหมวดหมู่ไม่สำเร็จ');
    final items = jsonDecode(response.body) as List<dynamic>;
    return items
        .whereType<Map<String, Object?>>()
        .map(Category.fromJson)
        .toList();
  }

  Future<Category> addCategory(Category category) async {
    final response = await _client
        .post(
          _uri('/categories'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(category.toJson()),
        )
        .timeout(_timeout);
    _checkResponse(response, 'เพิ่มหมวดหมู่ไม่สำเร็จ', successCode: 201);
    return Category.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<Category> updateCategory(Category category) async {
    if (category.id == null) {
      throw Exception('ไม่พบรหัสหมวดหมู่สำหรับแก้ไข');
    }
    final response = await _client
        .put(
          _uri('/categories/${category.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(category.toJson()),
        )
        .timeout(_timeout);
    _checkResponse(response, 'แก้ไขหมวดหมู่ไม่สำเร็จ');
    return Category.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<void> deleteCategory(int id) async {
    final response = await _client
        .delete(_uri('/categories/$id'))
        .timeout(_timeout);
    _checkResponse(response, 'ลบหมวดหมู่ไม่สำเร็จ');
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
