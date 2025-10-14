import 'package:antifraud_flutter/antifraud_flutter.dart';
import 'package:antifraud_flutter/src/core/models/failure.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'antifraud_flutter_platform_interface.dart';

const _tag = 'Telecom AF --->';

/// An implementation of [AntifraudFlutterPlatform] that uses method channels.
class MethodChannelAntifraudFlutter extends AntifraudFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('antifraud_flutter');

  AntifraudFlutterLogger? _logger;

  String _host = '';

  void _printLog(String message,
      {required String method,
      required Map<String, dynamic>? request,
      required Map<String, dynamic>? response,
      int statusCode = 200}) {
    if (kDebugMode) {
      debugPrint('$_tag $message');
    }
    if (_logger != null) {
      _logger!.logChuck(method: method, statusCode: statusCode, response: response, request: request, host: _host);
    }
  }

  @override
  Future<Either<Failure, void>> init({required String host, AntifraudFlutterLogger? logger}) async {
    try {
      _host = host;
      _logger = logger;
      await methodChannel.invokeMethod<void>('init', {'host': host});
      _printLog('init host: $host', method: 'init', request: {'host': host}, response: {});
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('init host error: ${e.code} ${e.message}\n${e.stacktrace}',
          statusCode: 500, method: 'init', request: {'host': host}, response: {'message': e.message, 'code': e.code});
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      await methodChannel.invokeMethod<void>('initialize');
      _printLog('initialize', method: 'initialize', request: {'host': _host}, response: {});
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('initialize error: ${e.code} ${e.message}\n${e.stacktrace}',
          request: {'host': _host},
          statusCode: 500,
          method: 'initialize',
          response: {'message': e.message, 'code': e.code});
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<bool> isInitialized() async {
    try {
      final result = await methodChannel.invokeMethod<bool?>('is_initialized');
      _printLog('isInitialized', method: 'isInitialized', request: {}, response: {});
      return result ?? false;
    } on PlatformException catch (e) {
      _printLog('${e.code} ${e.message}\n${e.stacktrace}',
          request: {}, statusCode: 500, method: 'isInitialized', response: {'message': e.message, 'code': e.code});
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
      _printLog('verifySMSCode phoneNumber: $phoneNumber, code: $code',
          method: 'verify_sms_code', request: {'phone_number': phoneNumber, 'code': code}, response: {});
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog(
        'verifySMSCode error: ${e.code} ${e.message}\n${e.stacktrace}',
        statusCode: 500,
        method: 'verify_sms_code',
        response: {'message': e.message, 'code': e.code},
        request: {'phone_number': phoneNumber, 'code': code},
      );
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> detectFraud({required String code}) async {
    try {
      await methodChannel.invokeMethod<void>('detect_fraud', {'code': code});
      _printLog('detectFraud code: $code', method: 'detect_fraud', request: {'code': code}, response: {});
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('detectFraud error: ${e.code} ${e.message}\n${e.stacktrace}',
          statusCode: 500,
          method: 'detect_fraud',
          request: {'code': code},
          response: {'message': e.message, 'code': e.code});
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> makeOperation() async {
    try {
      await methodChannel.invokeMethod<void>('make_operation');
      _printLog('makeOperation', method: 'make_operation', request: {}, response: {});
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('makeOperation error: ${e.code} ${e.message}\n${e.stacktrace}',
          request: {}, statusCode: 500, method: 'make_operation', response: {'message': e.message, 'code': e.code});
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> confirmFace({required String document, required String birthDate}) async {
    try {
      await methodChannel.invokeMethod<void>('confirm_face', {'document': document, 'birth_date': birthDate});
      _printLog('confirmFace document: $document, birthDate: $birthDate',
          method: 'confirm_face', request: {'document': document, 'birth_date': birthDate}, response: {});
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog(
        'confirmFace error ${e.code} ${e.message}\n${e.stacktrace}',
        statusCode: 500,
        method: 'confirm_face',
        response: {'message': e.message, 'code': e.code},
        request: {'document': document, 'birth_date': birthDate},
      );
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, String>> getClientInstanceId() async {
    try {
      final result = await methodChannel.invokeMethod<String>('get_client_instance_id');
      _printLog('getClientInstanceId: $result',
          request: {}, method: 'get_client_instance_id', response: {'client_instance_id': result});
      return Right(result ?? '');
    } on PlatformException catch (e) {
      _printLog('getClientInstanceId error ${e.code} ${e.message}\n${e.stacktrace}',
          request: {},
          statusCode: 500,
          method: 'get_client_instance_id',
          response: {'message': e.message, 'code': e.code});
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await methodChannel.invokeMethod<void>('logout');
      _printLog('logout', method: 'logout', request: {}, response: {});
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('logout error: ${e.code} ${e.message}\n${e.stacktrace}',
          request: {}, statusCode: 500, method: 'logout', response: {'message': e.message, 'code': e.code});
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }
}
