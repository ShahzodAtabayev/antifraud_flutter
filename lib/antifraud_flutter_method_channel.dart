import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'antifraud_flutter_platform_interface.dart';

/// An implementation of [AntifraudFlutterPlatform] that uses method channels.
class MethodChannelAntifraudFlutter extends AntifraudFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('antifraud_flutter');

  @override
  Future<Either<String, void>> initialize({required String host}) async {
    try {
      await methodChannel.invokeMethod<void>(
        'initialize',
        {'host': host},
      );
      return const Right(null);
    } on PlatformException catch (e) {
      return Left(e.message ?? '');
    }
  }

  @override
  Future<Either<String, void>> verifySMSCode({required String phoneNumber, required String code}) async {
    try {
      await methodChannel.invokeMethod<void>(
        'verify_sms_code',
        {
          'phone_number': phoneNumber,
          'code': code,
        },
      );
      return const Right(null);
    } on PlatformException catch (e) {
      return Left(e.message ?? '');
    }
  }

  @override
  Future<Either<String, void>> detectFraud({required String code}) async {
    try {
      await methodChannel.invokeMethod<void>(
        'detect_fraud',
        {
          'code': code,
        },
      );
      return const Right(null);
    } on PlatformException catch (e) {
      return Left(e.message ?? '');
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      await methodChannel.invokeMethod<void>('logout');
      return const Right(null);
    } on PlatformException catch (e) {
      return Left(e.message ?? '');
    }
  }
}
