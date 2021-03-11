import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Au10tixResponse {
  final String type;
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

  static Future<Au10tixResponse> verifyId(
      {@required String token, @required String identification}) async {
    String type = '';
    String urlFront = '';
    String urlBack = '';
    String urlFace = '';

    try {
      final args = <String, dynamic>{
        'token': token,
        'identification': identification,
      };

      Map<String, dynamic> map = Map<String, dynamic>.from(
          await _channel.invokeMethod('verifyId', args));
      if (map.isNotEmpty &&
          map.containsKey('urlFront') &&
          map.containsKey('urlFace')) {
        urlFront = map['urlFront'];
        urlBack = map['urlBack'];
        urlFace = map['urlFace'];
        type = map['type'];
      }
    } catch (e) {
      print('====> error:: $e');
    }

    return Au10tixResponse(type, urlFront, urlBack, urlFace);
  }
}
