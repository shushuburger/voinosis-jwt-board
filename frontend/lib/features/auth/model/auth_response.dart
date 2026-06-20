class AuthResponse {
  const AuthResponse({
    required this.accessToken,
  });

  final String accessToken;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
    );
  }
}
