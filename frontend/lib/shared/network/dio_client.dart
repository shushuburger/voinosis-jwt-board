import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/shared/constants/api_constants.dart';
import 'package:voinosis_jwt_board/shared/network/jwt_auth_interceptor.dart';
import 'package:voinosis_jwt_board/shared/storage/secure_storage_service.dart';

class DioClient {
  DioClient({
    Dio? dio,
    SecureStorageService? secureStorage,
    OnUnauthorized? onUnauthorized,
  }) : _dio = dio ?? Dio(_baseOptions) {
    if (secureStorage != null) {
      _dio.interceptors.add(
        JwtAuthInterceptor(
          secureStorage: secureStorage,
          onUnauthorized: onUnauthorized,
        ),
      );
    }
  }

  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: ApiConstants.connectTimeout,
    receiveTimeout: ApiConstants.receiveTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final Dio _dio;

  Dio get dio => _dio;

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }
}
