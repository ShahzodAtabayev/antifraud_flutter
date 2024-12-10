import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antifraud_flutter/antifraud_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAntifraudFlutter platform = MethodChannelAntifraudFlutter();
  const MethodChannel channel = MethodChannel('antifraud_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'initialize') {
          return null;
        } else if (methodCall.method == 'verify_sms_code') {
          return null;
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('initialize', () async {
    expect(await platform.initialize(host: '', tokenType: '', accessToken: ''), null);
  });
}
