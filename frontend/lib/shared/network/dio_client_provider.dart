import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_provider.dart';
import 'package:voinosis_jwt_board/shared/network/dio_client.dart';
import 'package:voinosis_jwt_board/shared/storage/secure_storage_service_provider.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);

  return DioClient(
    secureStorage: secureStorage,
    onUnauthorized: () async {
      await ref.read(authProvider.notifier).logout();
    },
  );
});
