import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/shared/storage/secure_storage_service.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
