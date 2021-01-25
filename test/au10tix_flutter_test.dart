import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:au10tix_flutter/au10tix_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('au10tix_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Au10tixFlutter.platformVersion, '42');
  });
}
