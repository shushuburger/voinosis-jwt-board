import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/posts/provider/posts_provider.dart';

class PostsActions {
  PostsActions._();

  static Future<void> fetchInitialPosts(WidgetRef ref) {
    return ref.read(postsProvider.notifier).fetchInitialPosts();
  }

  static Future<void> fetchNextPage(WidgetRef ref) {
    return ref.read(postsProvider.notifier).fetchNextPage();
  }

  static Future<void> refreshPosts(WidgetRef ref) {
    return ref.read(postsProvider.notifier).refreshPosts();
  }
}
