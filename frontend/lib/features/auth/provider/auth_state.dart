export 'auth_status.dart';

import 'package:voinosis_jwt_board/features/auth/provider/auth_status.dart';

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.emailError,
    this.passwordError,
  });

  final AuthStatus status;
  final String? emailError;
  final String? passwordError;

  const AuthState.initial() : this();

  const AuthState.loading() : this(status: AuthStatus.loading);

  const AuthState.authenticated() : this(status: AuthStatus.authenticated);

  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);

  AuthState.error({
    String? emailError,
    String? passwordError,
  }) : this(
          status: AuthStatus.error,
          emailError: emailError,
          passwordError: passwordError,
        );

  AuthState copyWith({
    AuthStatus? status,
    String? emailError,
    String? passwordError,
    bool clearEmailError = false,
    bool clearPasswordError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError:
          clearPasswordError ? null : (passwordError ?? this.passwordError),
    );
  }
}
