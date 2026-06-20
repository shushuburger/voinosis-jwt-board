import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/shared/storage/secure_storage_service.dart';

typedef OnUnauthorized = void Function();

class JwtAuthInterceptor extends Interceptor {
  JwtAuthInterceptor({
    required SecureStorageService secureStorage,
    OnUnauthorized? onUnauthorized,
  })  : _secureStorage = secureStorage,
        _onUnauthorized = onUnauthorized;

  final SecureStorageService _secureStorage;
  final OnUnauthorized? _onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _onUnauthorized?.call();
    }

    handler.next(err);
  }
}
