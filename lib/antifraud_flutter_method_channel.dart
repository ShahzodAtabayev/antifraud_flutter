import 'package:antifraud_flutter/src/core/models/failure.dart';
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
  Future<Either<Failure, void>> init({required String host}) async {
    try {
      await methodChannel.invokeMethod<void>('init', {'host': host});
      return const Right(null);
    } on PlatformException catch (e) {
      debugPrint('PlatformException.code: ${e.code}');
      debugPrint('PlatformException.message: ${e.message}');
      debugPrint('PlatformException.details: ${e.details}');
      debugPrint('PlatformException.stacktrace: ${e.stacktrace}');
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      await methodChannel.invokeMethod<void>('initialize');
      return const Right(null);
    } on PlatformException catch (e) {
      debugPrint('PlatformException.code: ${e.code}');
      debugPrint('PlatformException.message: ${e.message}');
      debugPrint('PlatformException.details: ${e.details}');
      debugPrint('PlatformException.stacktrace: ${e.stacktrace}');
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<bool> isInitialized() async {
    try {
      final result = await methodChannel.invokeMethod<bool?>('is_initialized');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('PlatformException.code: ${e.code}');
      debugPrint('PlatformException.message: ${e.message}');
      debugPrint('PlatformException.details: ${e.details}');
      debugPrint('PlatformException.stacktrace: ${e.stacktrace}');
      return false;
    }
  }

  @override
  Future<Either<Failure, void>> verifySMSCode({required String phoneNumber, required String code}) async {
    try {
      await methodChannel.invokeMethod<void>(
        'verify_sms_code',
        {'phone_number': phoneNumber, 'code': code},
      );
      return const Right(null);
    } on PlatformException catch (e) {
      debugPrint('PlatformException.code: ${e.code}');
      debugPrint('PlatformException.message: ${e.message}');
      debugPrint('PlatformException.details: ${e.details}');
      debugPrint('PlatformException.stacktrace: ${e.stacktrace}');
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> detectFraud({required String code}) async {
    try {
      await methodChannel.invokeMethod<void>('detect_fraud', {'code': code});
      return const Right(null);
    } on PlatformException catch (e) {
      debugPrint('PlatformException.code: ${e.code}');
      debugPrint('PlatformException.message: ${e.message}');
      debugPrint('PlatformException.details: ${e.details}');
      debugPrint('PlatformException.stacktrace: ${e.stacktrace}');
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> makeOperation() async {
    try {
      await methodChannel.invokeMethod<void>('make_operation');
      return const Right(null);
    } on PlatformException catch (e) {
      debugPrint('PlatformException.code: ${e.code}');
      debugPrint('PlatformException.message: ${e.message}');
      debugPrint('PlatformException.details: ${e.details}');
      debugPrint('PlatformException.stacktrace: ${e.stacktrace}');
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> confirmFace({required String document, required String birthDate}) async {
    try {
      await methodChannel.invokeMethod<void>('confirm_face', {'document': document, 'birth_date': birthDate});
      return const Right(null);
    } on PlatformException catch (e) {
      debugPrint('PlatformException.code: ${e.code}');
      debugPrint('PlatformException.message: ${e.message}');
      debugPrint('PlatformException.details: ${e.details}');
      debugPrint('PlatformException.stacktrace: ${e.stacktrace}');
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, String>> getClientInstanceId() async {
    try {
      final result = await methodChannel.invokeMethod<String>('get_client_instance_id');
      return Right(result ?? '');
    } on PlatformException catch (e) {
      debugPrint('PlatformException.code: ${e.code}');
      debugPrint('PlatformException.message: ${e.message}');
      debugPrint('PlatformException.details: ${e.details}');
      debugPrint('PlatformException.stacktrace: ${e.stacktrace}');
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await methodChannel.invokeMethod<void>('logout');
      return const Right(null);
    } on PlatformException catch (e) {
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }
}
