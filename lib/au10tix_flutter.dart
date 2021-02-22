import 'dart:async';
import 'package:flutter/services.dart';

class Au10tixResponse {
  final String type;
  final bool isFront;
  final String imagePath;

  Au10tixResponse(
    this.type,
    this.isFront,
    this.imagePath,
  );
}

class Au10tixFlutter {
  static const _channel = MethodChannel('au10tix_flutter');

  static Future<Au10tixResponse> verifyId(
      String token, bool isFront, String identification) async {
    try {
      final args = <String, dynamic>{
        'token': token,
        'isFront': isFront,
        'identification': identification,
      };

      Map<String, dynamic> map = Map<String, dynamic>.from(
          await _channel.invokeMethod('verifyId', args));
      String urlImage = map['urlImage'];
      bool isFrontRes = map['isFront'];
      String type = map['type'];
      return Au10tixResponse(type, isFrontRes, urlImage);
    } catch (e) {
      print('====> error:: $e');
    }

    return null;
  }
}
