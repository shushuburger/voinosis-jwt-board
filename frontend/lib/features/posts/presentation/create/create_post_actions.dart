import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_form_actions.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/create_post_ui_text.dart';
import 'package:voinosis_jwt_board/features/posts/provider/create_post_provider.dart';
import 'package:voinosis_jwt_board/features/posts/provider/create_post_state.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';
import 'package:voinosis_jwt_board/shared/utils/snackbar_utils.dart';

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
    if (ref.read(createPostProvider).isSubmitting) {
      return Future.value();
    }

    return AuthFormActions.submitIfValid(
      formKey: formKey,
      action: () => ref.read(createPostProvider.notifier).submitPost(
            title: title,
            content: content,
          ),
    );
  }

  static void handleStateChange({
    required BuildContext context,
    required CreatePostState? previous,
    required CreatePostState next,
  }) {
    if (next.isSuccess && previous?.isSuccess != true) {
      SnackBarUtils.showMessage(context, CreatePostUiText.successMessage);
      context.go(RoutePaths.home);
      return;
    }

    final errorMessage = next.errorMessage;
    if (errorMessage == null || next.isSubmitting) {
      return;
    }

    if (previous?.errorMessage == errorMessage) {
      return;
    }

    SnackBarUtils.showError(context, errorMessage);
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
