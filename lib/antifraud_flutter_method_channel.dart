import 'package:antifraud_flutter/src/core/models/failure.dart';
import 'package:chuck_interceptor/chuck.dart';
import 'package:chuck_interceptor/model/chuck_http_call.dart';
import 'package:chuck_interceptor/model/chuck_http_request.dart';
import 'package:chuck_interceptor/model/chuck_http_response.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'antifraud_flutter_platform_interface.dart';

const _tag = 'Telecom AF --->';

Chuck _chuck = Chuck();

/// An implementation of [AntifraudFlutterPlatform] that uses method channels.
class MethodChannelAntifraudFlutter extends AntifraudFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('antifraud_flutter');

  String _host = '';

  bool _enableChuck = false;

  void _printLog(String message,
      {String method = '', Map<String, dynamic>? request, Map<String, dynamic>? response, int statusCode = 200}) {
    if (kDebugMode) {
      debugPrint('$_tag $message');
    }
    if (_enableChuck) {
      final ChuckHttpCall call = ChuckHttpCall(message.hashCode, DateTime.now());
      call.server = _host;
      call.endpoint = method;
      call.method = 'POST';
      call.request = ChuckHttpRequest(time: DateTime.now(), size: 1, body: request);
      call.response = ChuckHttpResponse(
        body: response,
        status: statusCode,
        time: DateTime.now(),
        headers: {'Content-Type': 'application/json'},
      );
      call.loading = false;
      _chuck.getDioInterceptor().chuckCore.addCall(call);
    }
  }

  @override
  Future<Either<Failure, void>> init({required String host, bool enableChuck = false}) async {
    try {
      _host = host;
      _enableChuck = enableChuck;
      await methodChannel.invokeMethod<void>('init', {'host': host});
      _printLog('init host: $host', method: 'init', request: {'host': host});
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('init host error: ${e.code} ${e.message}\n${e.stacktrace}', statusCode: 500);
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      await methodChannel.invokeMethod<void>('initialize');
      _printLog('initialize', method: 'initialize');
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('initialize error: ${e.code} ${e.message}\n${e.stacktrace}', statusCode: 500);
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<bool> isInitialized() async {
    try {
      final result = await methodChannel.invokeMethod<bool?>('is_initialized');
      _printLog('isInitialized');
      return result ?? false;
    } on PlatformException catch (e) {
      _printLog('${e.code} ${e.message}\n${e.stacktrace}', statusCode: 500);
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
      _printLog('verifySMSCode phoneNumber: $phoneNumber, code: $code');
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('verifySMSCode error: ${e.code} ${e.message}\n${e.stacktrace}', statusCode: 500);
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> detectFraud({required String code}) async {
    try {
      await methodChannel.invokeMethod<void>('detect_fraud', {'code': code});
      _printLog(
        'detectFraud code: $code',
      );
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('detectFraud error: ${e.code} ${e.message}\n${e.stacktrace}', statusCode: 500);
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> makeOperation() async {
    try {
      await methodChannel.invokeMethod<void>('make_operation');
      _printLog('makeOperation');
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('makeOperation error: ${e.code} ${e.message}\n${e.stacktrace}', statusCode: 500);
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> confirmFace({required String document, required String birthDate}) async {
    try {
      await methodChannel.invokeMethod<void>('confirm_face', {'document': document, 'birth_date': birthDate});
      _printLog('confirmFace document: $document, birthDate: $birthDate');
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('confirmFace error ${e.code} ${e.message}\n${e.stacktrace}', statusCode: 500);
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, String>> getClientInstanceId() async {
    try {
      final result = await methodChannel.invokeMethod<String>('get_client_instance_id');
      _printLog('getClientInstanceId: $result');
      return Right(result ?? '');
    } on PlatformException catch (e) {
      _printLog('getClientInstanceId error ${e.code} ${e.message}\n${e.stacktrace}', statusCode: 500);
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await methodChannel.invokeMethod<void>('logout');
      _printLog('logout');
      return const Right(null);
    } on PlatformException catch (e) {
      _printLog('logout error: ${e.code} ${e.message}\n${e.stacktrace}', statusCode: 500);
      return Left(Failure(code: e.code, message: e.message ?? ''));
    }
  }
}
