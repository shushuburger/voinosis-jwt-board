import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/shared/constants/error_messages.dart';

enum AuthErrorContext {
  login,
  signup,
}

class AuthFieldErrors {
  const AuthFieldErrors({
    this.email,
    this.password,
    this.fallbackMessage,
  });

  final String? email;
  final String? password;
  final String? fallbackMessage;

  bool get hasFieldError => email != null || password != null;

  static AuthFieldErrors forLogin(Object error) =>
      _resolve(error, AuthErrorContext.login);

  static AuthFieldErrors forSignup(Object error) =>
      _resolve(error, AuthErrorContext.signup);

  static AuthFieldErrors _resolve(Object error, AuthErrorContext context) {
    if (error is! DioException) {
      return const AuthFieldErrors(fallbackMessage: ErrorMessages.unknown);
    }

    if (_isNetworkError(error)) {
      return const AuthFieldErrors(password: ErrorMessages.network);
    }

    final statusCode = error.response?.statusCode;
    final serverMessage = _extractServerMessage(error.response?.data);

    switch (statusCode) {
      case 400:
        return AuthFieldErrors(
          email: serverMessage ?? ErrorMessages.validationFailed,
        );
      case 401:
        return context == AuthErrorContext.login
            ? const AuthFieldErrors(password: ErrorMessages.loginFailed)
            : const AuthFieldErrors(fallbackMessage: ErrorMessages.signupFailed);
      case 409:
        return const AuthFieldErrors(email: ErrorMessages.emailAlreadyExists);
      default:
        return switch (context) {
          AuthErrorContext.login =>
            const AuthFieldErrors(password: ErrorMessages.loginFailed),
          AuthErrorContext.signup => AuthFieldErrors(
              email: serverMessage ?? ErrorMessages.signupFailed,
            ),
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
