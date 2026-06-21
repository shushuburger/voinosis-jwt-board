class ApiRequestException implements Exception {
  const ApiRequestException({required this.message});

  final String message;

  @override
  String toString() => message;
}
