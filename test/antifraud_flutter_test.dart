import 'package:antifraud_flutter/src/core/models/failure.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antifraud_flutter/antifraud_flutter.dart';
import 'package:antifraud_flutter/antifraud_flutter_platform_interface.dart';
import 'package:antifraud_flutter/antifraud_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAntifraudFlutterPlatform with MockPlatformInterfaceMixin implements AntifraudFlutterPlatform {
  @override
  Future<Either<Failure, void>> initialize() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isInitialized() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> logout() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> verifySMSCode({required String phoneNumber, required String code}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> detectFraud({required String code}) {
    // TODO: implement detectFraud
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> confirmFace({required String document, required String birthDate}) {
    // TODO: implement confirmFace
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> makeOperation() {
    // TODO: implement makeOperation
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getClientInstanceId() {
    // TODO: implement getClientInstanceId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> init({required String host, bool enableChuck = false}) {
    // TODO: implement init
    throw UnimplementedError();
  }
}

void main() {
  final AntifraudFlutterPlatform initialPlatform = AntifraudFlutterPlatform.instance;

  test(
    '$MethodChannelAntifraudFlutter is the default instance',
    () {
      expect(initialPlatform, isInstanceOf<MethodChannelAntifraudFlutter>());
    },
  );

  test(
    'initialize',
    () async {
      MockAntifraudFlutterPlatform fakePlatform = MockAntifraudFlutterPlatform();
      AntifraudFlutterPlatform.instance = fakePlatform;

      expect(await AntifraudFlutter(host: '').initialize(), null);
    },
  );
}
