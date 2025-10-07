import 'package:either_dart/either.dart';

import 'antifraud_flutter_platform_interface.dart';

final class AntifraudFlutter {
  Future<Either<String, void>> initialize({required String host}) {
    return AntifraudFlutterPlatform.instance.initialize(host: host);
  }

  Future<Either<String, bool>> isInitialized() {
    return AntifraudFlutterPlatform.instance.isInitialized();
  }

  Future<Either<String, void>> verifySMSCode({required String phoneNumber, required String code}) {
    return AntifraudFlutterPlatform.instance.verifySMSCode(code: code, phoneNumber: phoneNumber);
  }

  Future<Either<String, void>> detectFraud({required String code}) {
    return AntifraudFlutterPlatform.instance.detectFraud(code: code);
  }

  Future<Either<String, void>> makeOperation() {
    return AntifraudFlutterPlatform.instance.makeOperation();
  }

  Future<Either<String, void>> confirmFace({required String document, required String birthDate}) {
    return AntifraudFlutterPlatform.instance.confirmFace(document: document, birthDate: birthDate);
  }

  Future<Either<String, void>> logout() {
    return AntifraudFlutterPlatform.instance.logout();
  }
}
