import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiService extends GetxService {
  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('${ApiConfig.baseUrl}/$cleanPath').replace(
      queryParameters: query?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    return _request(() => http.get(_uri(path, query)));
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    return _request(
      () => http.post(_uri(path), headers: _headers, body: jsonEncode(body)),
    );
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    return _request(
      () => http.put(_uri(path), headers: _headers, body: jsonEncode(body)),
    );
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    return _request(
      () => http.patch(_uri(path), headers: _headers, body: jsonEncode(body)),
    );
  }

  Future<void> delete(String path) async {
    await _request(() => http.delete(_uri(path)));
  }

  Map<String, String> get _headers => {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  Future<dynamic> _request(Future<http.Response> Function() callback) async {
    try {
      final response = await callback();
      final status = response.statusCode;
      final rawBody = response.body;
      final body = rawBody.isEmpty ? null : _decodeBody(rawBody);

      if (status >= 200 && status < 300) {
        return body;
      }

      throw _mapError(status, body);
    } on SocketException {
      throw 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาตรวจสอบ json-server';
    } catch (error) {
      rethrow;
    }
  }

  dynamic _decodeBody(String rawBody) {
    try {
      return jsonDecode(rawBody);
    } catch (_) {
      return rawBody;
    }
  }

  String _mapError(int status, dynamic body) {
    final message = body is Map<String, dynamic> ? body['message'] : null;
    final plainText = body is String ? body : null;
    switch (status) {
      case 400:
        return message?.toString() ?? plainText ?? 'ข้อมูลไม่ถูกต้อง';
      case 404:
        return plainText == 'Not Found'
            ? 'ไม่พบข้อมูลที่ต้องการ'
            : plainText ?? 'ไม่พบข้อมูลที่ต้องการ';
      case 500:
        return plainText ?? 'เกิดข้อผิดพลาดภายในเซิร์ฟเวอร์';
      default:
        return message?.toString() ??
            plainText ??
            'เกิดข้อผิดพลาดในการเชื่อมต่อ';
    }
  }
}
