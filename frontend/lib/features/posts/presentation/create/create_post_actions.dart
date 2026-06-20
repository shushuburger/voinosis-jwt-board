import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/posts/provider/create_post_provider.dart';

class CreatePostActions {
  CreatePostActions._();

  static void reset(WidgetRef ref) {
    ref.read(createPostProvider.notifier).reset();
  }

  static Future<void> submit({
    required WidgetRef ref,
    required String title,
    required String content,
  }) {
    return ref.read(createPostProvider.notifier).submitPost(
          title: title,
          content: content,
        );
  }

  static void goBack({
    required BuildContext context,
    required bool isSubmitting,
  }) {
    if (isSubmitting) {
      return;
    }

    context.pop();
  }
}
