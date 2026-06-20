import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_form_actions.dart';
import 'package:voinosis_jwt_board/features/posts/provider/create_post_provider.dart';
import 'package:voinosis_jwt_board/features/posts/provider/create_post_state.dart';

class CreatePostActions {
  CreatePostActions._();

  static void reset(WidgetRef ref) {
    ref.read(createPostProvider.notifier).reset();
  }

  static Future<void> submit({
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required String title,
    required String content,
  }) {
    return AuthFormActions.submitIfValid(
      formKey: formKey,
      action: () => ref.read(createPostProvider.notifier).submitPost(
            title: title.trim(),
            content: content.trim(),
          ),
    );
  }

  static void handleStateChange({
    required BuildContext context,
    required CreatePostState? previous,
    required CreatePostState next,
  }) {
    final errorMessage = next.errorMessage;
    if (errorMessage == null || next.isSubmitting) {
      return;
    }

    if (previous?.errorMessage == errorMessage) {
      return;
    }

    AuthFormActions.showErrorSnackBar(context, errorMessage);
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
