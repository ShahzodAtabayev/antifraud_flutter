import 'antifraud_flutter_platform_interface.dart';
import 'package:either_dart/src/either.dart';

class AntifraudFlutter {
  static Future<Either<String, void>> initialize({
    required String host,
    required String tokenType,
    required String accessToken,
  }) {
    return AntifraudFlutterPlatform.instance.initialize(
      host: host,
      tokenType: tokenType,
      accessToken: accessToken,
    );
  }

  static Future<Either<String, void>> verifySMSCode({required String phoneNumber, required String code}) {
    return AntifraudFlutterPlatform.instance.verifySMSCode(code: code, phoneNumber: phoneNumber);
  }

  static Future<Either<String, void>> logout() {
    return AntifraudFlutterPlatform.instance.logout();
  }

  static Future<Either<String, void>> refreshToken({required String token}) {
    return AntifraudFlutterPlatform.instance.refreshToken(token: token);
  }
}
