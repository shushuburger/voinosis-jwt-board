import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_text.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_centered_state_view.dart';
import 'package:voinosis_jwt_board/shared/widgets/app_primary_button.dart';

class PostsErrorView extends StatelessWidget {
  const PostsErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return PostsCenteredStateView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: PostsUiConstants.errorColor,
          ),
          const SizedBox(height: PostsUiConstants.stateIconTextSpacing),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: PostsUiConstants.stateBodyFontSize,
              height: 1.5,
              color: PostsUiConstants.errorColor,
            ),
          ),
          const SizedBox(height: PostsUiConstants.stateMessageButtonSpacing),
          AppPrimaryButton(
            label: PostsUiText.retryButton,
            onPressed: onRetry,
            minimumSize: PostsUiConstants.retryButtonSize,
          ),
        ],
      ),
    );
  }
}
