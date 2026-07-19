import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _port = '3000';

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:$_port';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:$_port';
    }

    if (Platform.isIOS || Platform.isMacOS) {
      return 'http://127.0.0.1:$_port';
    }

    return 'http://localhost:$_port';
  }

  static String realDeviceUrl(String host) => 'http://$host:$_port';
}
