import 'package:voinosis_jwt_board/shared/constants/storage_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) async {
    await _storage.write(key: StorageConstants.jwtTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: StorageConstants.jwtTokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: StorageConstants.jwtTokenKey);
  }
}
