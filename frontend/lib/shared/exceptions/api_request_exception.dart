class ApiRequestException implements Exception {
  const ApiRequestException({
    required this.message,
    this.isSessionExpired = false,
  });

  final String message;
  final bool isSessionExpired;

  @override
  String toString() => message;
}
