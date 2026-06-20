import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/posts/data/posts_repository.dart';
import 'package:voinosis_jwt_board/shared/network/dio_client_provider.dart';

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PostsRepository(dio: dioClient.dio);
});
