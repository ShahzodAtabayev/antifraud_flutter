import 'package:either_dart/either.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'antifraud_flutter_method_channel.dart';

abstract class AntifraudFlutterPlatform extends PlatformInterface {
  /// Constructs a AntifraudFlutterPlatform.
  AntifraudFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static AntifraudFlutterPlatform _instance = MethodChannelAntifraudFlutter();

  /// The default instance of [AntifraudFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelAntifraudFlutter].
  static AntifraudFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AntifraudFlutterPlatform] when
  /// they register themselves.
  static set instance(AntifraudFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Either<String, void>> initialize({
    required String host,
    required String tokenType,
    required String accessToken,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<Either<String, void>> verifySMSCode({required String phoneNumber, required String code}) {
    throw UnimplementedError('verifySMSCode() has not been implemented.');
  }

  Future<Either<String, void>> logout() {
    throw UnimplementedError('logout() has not been implemented.');
  }

  Future<Either<String, void>> refreshToken({required String token}) {
    throw UnimplementedError('refreshToken() has not been implemented.');
  }
}
