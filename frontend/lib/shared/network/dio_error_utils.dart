import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/shared/constants/error_messages.dart';

abstract final class DioErrorUtils {
  static bool isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
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

  static String genericMessage(DioException error) {
    if (isNetworkError(error)) {
      return ErrorMessages.network;
    }

    final serverMessage = extractServerMessage(error.response?.data);
    if (serverMessage != null) {
      return serverMessage;
    }

    return ErrorMessages.unknown;
  }
}
