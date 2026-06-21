import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_text.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_centered_state_view.dart';

class PostsEmptyView extends StatelessWidget {
  const PostsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return PostsCenteredStateView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 48,
            color: PostsUiConstants.subtitleColor.withValues(alpha: 0.6),
          ),
          const SizedBox(height: PostsUiConstants.stateIconTextSpacing),
          const Text(
            PostsUiText.emptyTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: PostsUiConstants.stateTitleFontSize,
              fontWeight: FontWeight.w600,
              color: PostsUiConstants.headingColor,
            ),
          ),
          const SizedBox(height: PostsUiConstants.stateTitleSubtitleSpacing),
          const Text(
            PostsUiText.emptySubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: PostsUiConstants.stateBodyFontSize,
              height: 1.5,
              color: PostsUiConstants.subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
