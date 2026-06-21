import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_validation_constants.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_message_constants.dart';

class AuthValidators {
  AuthValidators._();

  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return AuthValidationMessages.emailRequired;
    }

    if (!_emailRegex.hasMatch(email)) {
      return AuthValidationMessages.emailInvalid;
    }

    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return AuthValidationMessages.passwordRequired;
    }

    if (password.length < AuthValidationConstants.passwordMinLength) {
      return AuthValidationMessages.passwordMinLength(
        AuthValidationConstants.passwordMinLength,
      );
    }

    return null;
  }
}
