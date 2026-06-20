import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/auth/data/auth_repository.dart';
import 'package:voinosis_jwt_board/shared/network/dio_client_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRepository(dio: dioClient.dio);
});
