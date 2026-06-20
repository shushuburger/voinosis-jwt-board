import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_form_actions.dart';
import 'package:voinosis_jwt_board/features/posts/data/posts_repository.dart';
import 'package:voinosis_jwt_board/features/posts/provider/posts_provider.dart';

class PostsActions {
  PostsActions._();

  static Future<void> fetchInitialPosts(WidgetRef ref) {
    return ref.read(postsProvider.notifier).fetchInitialPosts();
  }

  static Future<void> fetchNextPage(WidgetRef ref) {
    return ref.read(postsProvider.notifier).fetchNextPage();
  }

  static Future<void> refreshPosts({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      await ref.read(postsProvider.notifier).refreshPosts();
    } on PostsFetchException catch (error) {
      if (context.mounted) {
        AuthFormActions.showErrorSnackBar(context, error.message);
      }
    }
  }

  static void onCreatePressed() {
    // TODO(Issue #9): auth 확인 후 /posts/create 또는 /login 이동 (Step 7)
  }
}
