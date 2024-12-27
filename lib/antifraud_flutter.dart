import 'antifraud_flutter_platform_interface.dart';
import 'package:either_dart/src/either.dart';

class AntifraudFlutter {
  static Future<Either<String, void>> initialize({
    required String host,
  }) {
    return AntifraudFlutterPlatform.instance.initialize(host: host);
  }

  static Future<Either<String, void>> verifySMSCode({required String phoneNumber, required String code}) {
    return AntifraudFlutterPlatform.instance.verifySMSCode(code: code, phoneNumber: phoneNumber);
  }

  static Future<Either<String, void>> detectFraud({required String phoneNumber, required String code}) {
    return AntifraudFlutterPlatform.instance.detectFraud(code: code);
  }

  static Future<Either<String, void>> logout() {
    return AntifraudFlutterPlatform.instance.logout();
  }
}
