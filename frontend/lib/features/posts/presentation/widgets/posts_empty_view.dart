import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_text.dart';

class PostsEmptyView extends StatelessWidget {
  const PostsEmptyView({super.key});

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
            Icon(
              Icons.article_outlined,
              size: 48,
              color: PostsUiConstants.subtitleColor.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            const Text(
              PostsUiText.emptyTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: PostsUiConstants.headingColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              PostsUiText.emptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: PostsUiConstants.subtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
