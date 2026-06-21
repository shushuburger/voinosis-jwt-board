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
}

enum AuthErrorContext {
  login,
  signup,
}
