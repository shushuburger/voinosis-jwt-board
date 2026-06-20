import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_message_constants.dart';

class AuthErrorMessage {
  AuthErrorMessage._();

  static String forLogin(String message) {
    if (_isNetworkError(message)) {
      return AuthErrorMessages.network;
    }

    if (message.contains(AuthErrorPatterns.dioException)) {
      return AuthErrorMessages.loginFailed;
    }

    return message;
  }

  static String forSignup(String message) {
    if (_isNetworkError(message)) {
      return AuthErrorMessages.network;
    }

    if (message.contains(AuthErrorPatterns.statusCode409) ||
        message.contains(AuthErrorPatterns.emailAlreadyExists)) {
      return AuthErrorMessages.emailAlreadyExists;
    }

    if (message.contains(AuthErrorPatterns.dioException)) {
      return AuthErrorMessages.signupFailed;
    }

    return message;
  }

  static bool _isNetworkError(String message) {
    return message.contains(AuthErrorPatterns.socketException) ||
        message.contains(AuthErrorPatterns.connectionRefused) ||
        message.contains(AuthErrorPatterns.connectionError);
  }
}
