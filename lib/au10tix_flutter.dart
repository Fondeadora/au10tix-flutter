import 'dart:async';

import 'package:flutter/services.dart';

enum DocumentType {
  id,
  passport,
  none,
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

  static Future<Au10tixResponse> verifyId(String token) async {
    DocumentType type = DocumentType.none;
    String urlFront = '';
    String urlBack = '';
    String urlFace = '';

    try {
      final args = <String, dynamic>{
        'token': token,
      };

      Map<String, dynamic> map = Map<String, dynamic>.from(
          await _channel.invokeMethod('verifyId', args));
      urlFront = map['urlFront'];
      urlBack = map['urlBack'];
      urlFace = map['urlFace'];
      type = urlBack == '' ? DocumentType.passport : DocumentType.id;
    } catch (e) {
      print('====> error:: $e');
    }

    return Au10tixResponse(type, urlFront, urlBack, urlFace);
  }
}
