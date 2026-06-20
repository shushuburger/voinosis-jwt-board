import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Color(0xFFDC2626),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: PostsUiConstants.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(120, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(PostsUiText.retryButton),
            ),
          ],
        ),
      ),
    );
  }
}
