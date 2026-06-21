import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/features/auth/data/auth_error_context.dart';
import 'package:voinosis_jwt_board/features/auth/data/auth_field_errors.dart';
import 'package:voinosis_jwt_board/shared/constants/error_messages.dart';
import 'package:voinosis_jwt_board/shared/exceptions/api_request_exception.dart';
import 'package:voinosis_jwt_board/shared/network/dio_error_utils.dart';

abstract final class DioExceptionMapper {
  static ApiRequestException toApiRequestException(DioException error) {
    return ApiRequestException(message: toUserMessage(error));
  }

  static String toUserMessage(DioException error) {
    if (DioErrorUtils.isNetworkError(error)) {
      return ErrorMessages.network;
    }

    if (DioErrorUtils.isUnauthorized(error)) {
      return ErrorMessages.sessionExpired;
    }

    final serverMessage = DioErrorUtils.extractServerMessage(error.response?.data);
    if (serverMessage != null) {
      return serverMessage;
    }

    return ErrorMessages.unknown;
  }

  static AuthFieldErrors toAuthFieldErrors(
    DioException error,
    AuthErrorContext context,
  ) {
    if (DioErrorUtils.isNetworkError(error)) {
      return const AuthFieldErrors(password: ErrorMessages.network);
    }

    final statusCode = error.response?.statusCode;
    final serverMessage =
        DioErrorUtils.extractServerMessage(error.response?.data);

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
}
