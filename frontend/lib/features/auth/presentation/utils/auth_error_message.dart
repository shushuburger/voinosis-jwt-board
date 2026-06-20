import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/shared/constants/error_messages.dart';

enum AuthErrorContext {
  login,
  signup,
}

class AuthErrorMessage {
  AuthErrorMessage._();

  static String forLogin(Object error) => _resolve(error, AuthErrorContext.login);

  static String forSignup(Object error) =>
      _resolve(error, AuthErrorContext.signup);

  static String _resolve(Object error, AuthErrorContext context) {
    if (error is! DioException) {
      return ErrorMessages.unknown;
    }

    if (_isNetworkError(error)) {
      return ErrorMessages.network;
    }

    final statusCode = error.response?.statusCode;
    final serverMessage = _extractServerMessage(error.response?.data);

    switch (statusCode) {
      case 400:
        return serverMessage ?? ErrorMessages.validationFailed;
      case 401:
        return context == AuthErrorContext.login
            ? ErrorMessages.loginFailed
            : ErrorMessages.signupFailed;
      case 409:
        return ErrorMessages.emailAlreadyExists;
      default:
        return switch (context) {
          AuthErrorContext.login => ErrorMessages.loginFailed,
          AuthErrorContext.signup =>
            serverMessage ?? ErrorMessages.signupFailed,
        };
    }
  }

  static bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }

  static String? _extractServerMessage(dynamic data) {
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
