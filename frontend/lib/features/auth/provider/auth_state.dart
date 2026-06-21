enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.emailError,
    this.passwordError,
  });

  final AuthStatus status;
  final String? errorMessage;
  final String? emailError;
  final String? passwordError;

  const AuthState.initial() : this();

  const AuthState.loading() : this(status: AuthStatus.loading);

  const AuthState.authenticated() : this(status: AuthStatus.authenticated);

  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);

  AuthState.error({
    String? message,
    String? emailError,
    String? passwordError,
  }) : this(
          status: AuthStatus.error,
          errorMessage: message,
          emailError: emailError,
          passwordError: passwordError,
        );

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? emailError,
    String? passwordError,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError:
          clearPasswordError ? null : (passwordError ?? this.passwordError),
    );
  }
}
