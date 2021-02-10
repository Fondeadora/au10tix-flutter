import 'dart:async';
import 'dart:collection';

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

      HashMap<String, String> map =
          await _channel.invokeMethod('verifyId', args);
      urlFront = map[0];
      urlBack = map[1];
      urlFace = map[2];
      type = urlFront == '' ? DocumentType.passport : DocumentType.id;
    } catch (e) {
      print('====> error:: $e');
    }

    return Au10tixResponse(
      type,
      urlFront,
      urlBack,
      urlFace,
    );
  }
}
