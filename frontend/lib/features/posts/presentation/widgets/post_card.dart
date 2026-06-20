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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PostsUiConstants.cardBackgroundColor,
        borderRadius: BorderRadius.circular(PostsUiConstants.cardBorderRadius),
        border: Border.all(color: PostsUiConstants.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: PostsUiConstants.headingColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: PostsUiConstants.subtitleColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${PostsUiText.authorPrefix} #${post.authorId} · ${_formatDate(post.createdAt)}',
            style: const TextStyle(
              fontSize: 12,
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
