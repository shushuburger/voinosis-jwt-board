import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_primary_button.dart';

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PostsUiConstants.stateViewHorizontalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: PostsUiConstants.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: PostsUiConstants.errorColor,
              ),
            ),
            const SizedBox(height: 20),
            PostsPrimaryButton(
              label: PostsUiText.retryButton,
              onPressed: onRetry,
              minimumSize: PostsUiConstants.retryButtonSize,
            ),
          ],
        ),
      ),
    );
  }
}
