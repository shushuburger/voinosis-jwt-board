import 'package:voinosis_jwt_board/features/auth/data/auth_field_errors.dart';

class AuthException implements Exception {
  const AuthException(this.fieldErrors);

  final AuthFieldErrors fieldErrors;

  @override
  String toString() =>
      fieldErrors.fallbackMessage ??
      fieldErrors.email ??
      fieldErrors.password ??
      'AuthException';
}
