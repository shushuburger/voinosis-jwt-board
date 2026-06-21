import 'package:dio/dio.dart';

abstract final class DioErrorUtils {
  static bool isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }

  static bool isUnauthorized(DioException error) {
    return error.response?.statusCode == 401;
  }

  static String? extractServerMessage(dynamic data) {
    if (data is! Map) {
      return null;
    }

    final message = data['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }

    if (message is List) {
      return message.whereType<String>().join('\n');
    }

    return null;
  }
}
