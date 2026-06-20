import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/shared/network/dio_client.dart';
import 'package:voinosis_jwt_board/shared/storage/secure_storage_service_provider.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);

  return DioClient(
    secureStorage: secureStorage,
    onUnauthorized: () {
      // Step 6/7: authProvider.logout() 및 로그인 화면 이동 연결 예정
      secureStorage.deleteToken();
    },
  );
});
