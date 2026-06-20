import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _jwtTokenKey = 'jwt_token';

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) async {
    await _storage.write(key: _jwtTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _jwtTokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _jwtTokenKey);
  }
}
