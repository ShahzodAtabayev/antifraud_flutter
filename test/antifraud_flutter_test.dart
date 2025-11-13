import 'package:antifraud_flutter/src/core/models/failure.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antifraud_flutter/antifraud_flutter.dart';
import 'package:antifraud_flutter/antifraud_flutter_platform_interface.dart';
import 'package:antifraud_flutter/antifraud_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAntifraudFlutterPlatform with MockPlatformInterfaceMixin implements AntifraudFlutterPlatform {
  @override
  Future<Either<TAFFailure, void>> initialize() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isInitialized() {
    throw UnimplementedError();
  }

  @override
  Future<Either<TAFFailure, void>> logout() {
    throw UnimplementedError();
  }

  @override
  Future<Either<TAFFailure, void>> verifySMSCode({required String phoneNumber, required String code}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<TAFFailure, void>> detectFraud({required String code}) {
    // TODO: implement detectFraud
    throw UnimplementedError();
  }

  @override
  Future<Either<TAFFailure, void>> confirmFace({required String document, required String birthDate}) {
    // TODO: implement confirmFace
    throw UnimplementedError();
  }

  @override
  Future<Either<TAFFailure, void>> makeOperation() {
    // TODO: implement makeOperation
    throw UnimplementedError();
  }

  @override
  Future<Either<TAFFailure, String>> getClientInstanceId() {
    // TODO: implement getClientInstanceId
    throw UnimplementedError();
  }

  @override
  Future<Either<TAFFailure, void>> init({required String host, AntifraudFlutterLogger? logger}) {
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
