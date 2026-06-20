import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/shared/constants/api_constants.dart';

class DioClient {
  DioClient({Dio? dio}) : _dio = dio ?? Dio(_baseOptions);

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
