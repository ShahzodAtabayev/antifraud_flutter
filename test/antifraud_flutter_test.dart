import 'package:either_dart/src/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antifraud_flutter/antifraud_flutter.dart';
import 'package:antifraud_flutter/antifraud_flutter_platform_interface.dart';
import 'package:antifraud_flutter/antifraud_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAntifraudFlutterPlatform with MockPlatformInterfaceMixin implements AntifraudFlutterPlatform {
  @override
  Future<Either<String, void>> initialize({
    required String host,
    required String tokenType,
    required String accessToken,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, void>> logout() {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, void>> refreshToken({required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, void>> verifySMSCode({required String phoneNumber, required String code}) {
    throw UnimplementedError();
  }
}

void main() {
  final AntifraudFlutterPlatform initialPlatform = AntifraudFlutterPlatform.instance;

  test('$MethodChannelAntifraudFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAntifraudFlutter>());
  });

  test('initialize', () async {
    MockAntifraudFlutterPlatform fakePlatform = MockAntifraudFlutterPlatform();
    AntifraudFlutterPlatform.instance = fakePlatform;

    expect(await AntifraudFlutter.initialize(host: '', tokenType: '', accessToken: ''), null);
  });
}