import 'dart:async';

import 'package:flutter/services.dart';

class Au10tixFlutter {
  static const _channel = MethodChannel('au10tix_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
