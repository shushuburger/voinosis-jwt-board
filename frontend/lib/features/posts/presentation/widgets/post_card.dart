import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/model/post_model.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
  });

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PostsUiConstants.cardPadding),
      decoration: BoxDecoration(
        color: PostsUiConstants.cardBackgroundColor,
        borderRadius: BorderRadius.circular(PostsUiConstants.cardBorderRadius),
        border: Border.all(color: PostsUiConstants.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: PostsUiConstants.cardShadowAlpha,
            ),
            blurRadius: PostsUiConstants.cardShadowBlurRadius,
            offset: const Offset(0, PostsUiConstants.cardShadowOffsetY),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: PostsUiConstants.cardTitleFontSize,
              fontWeight: FontWeight.w600,
              color: PostsUiConstants.headingColor,
            ),
          ),
          const SizedBox(height: PostsUiConstants.cardTitleContentSpacing),
          Text(
            post.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: PostsUiConstants.cardContentFontSize,
              height: PostsUiConstants.cardContentLineHeight,
              color: PostsUiConstants.subtitleColor,
            ),
          ),
          const SizedBox(height: PostsUiConstants.cardContentDateSpacing),
          Text(
            _formatDate(post.createdAt),
            style: const TextStyle(
              fontSize: PostsUiConstants.cardDateFontSize,
              color: PostsUiConstants.subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final year = dateTime.year.toString();
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year.$month.$day';
  }
}
