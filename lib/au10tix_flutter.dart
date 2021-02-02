import 'dart:async';

import 'package:flutter/services.dart';

enum DocumentType {
  id,
  passport,
}

class Au10tixResponse {
  final DocumentType type;
  final String documentFrontPath;
  final String documentBackPath;
  final String selfiePath;

  Au10tixResponse(
    this.type,
    this.documentFrontPath,
    this.documentBackPath,
    this.selfiePath,
  );
}

class Au10tixFlutter {
  static const _channel = MethodChannel('au10tix_flutter');

  static Future<Au10tixResponse> verifyId({String token}) async {
    final args = {
      'token': token,
    };

    await _channel.invokeMethod('verifyId', args);

    return Au10tixResponse(
      DocumentType.passport,
      '',
      '',
      '',
    );
  }
}
