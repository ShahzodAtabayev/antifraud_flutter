import 'package:antifraud_flutter/src/core/models/failure.dart';
import 'package:either_dart/either.dart';

import 'antifraud_flutter_platform_interface.dart';

final class AntifraudFlutter {
  final String host;
  final AntifraudFlutterLogger? logger;

  AntifraudFlutter({required this.host, this.logger}) {
    AntifraudFlutterPlatform.instance.init(host: host, logger: logger);
  }

  Future<Either<Failure, void>> initialize() {
    return AntifraudFlutterPlatform.instance.initialize();
  }

  Future<bool> isInitialized() {
    return AntifraudFlutterPlatform.instance.isInitialized();
  }

  Future<Either<Failure, String>> getClientInstanceId() {
    return AntifraudFlutterPlatform.instance.getClientInstanceId();
  }

  Future<Either<Failure, void>> verifySMSCode({required String phoneNumber, required String code}) {
    return AntifraudFlutterPlatform.instance.verifySMSCode(code: code, phoneNumber: phoneNumber);
  }

  Future<Either<Failure, void>> detectFraud({required String code}) {
    return AntifraudFlutterPlatform.instance.detectFraud(code: code);
  }

  Future<Either<Failure, void>> makeOperation() {
    return AntifraudFlutterPlatform.instance.makeOperation();
  }

  Future<Either<Failure, void>> confirmFace({required String document, required String birthDate}) {
    return AntifraudFlutterPlatform.instance.confirmFace(document: document, birthDate: birthDate);
  }

  Future<Either<Failure, void>> logout() {
    return AntifraudFlutterPlatform.instance.logout();
  }
}

abstract class AntifraudFlutterLogger {
  void logChuck({
    required String host,
    required String method,
    Map<String, dynamic>? request,
    Map<String, dynamic>? response,
    int statusCode = 200,
  });
}
