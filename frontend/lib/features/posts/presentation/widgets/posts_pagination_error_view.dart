import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_text.dart';

class PostsPaginationErrorView extends StatelessWidget {
  const PostsPaginationErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: PostsUiConstants.compactBodyFontSize,
              color: PostsUiConstants.errorColor,
            ),
          ),
          const SizedBox(height: PostsUiConstants.paginationErrorSpacing),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              PostsUiText.retryButton,
              style: TextStyle(
                color: PostsUiConstants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
