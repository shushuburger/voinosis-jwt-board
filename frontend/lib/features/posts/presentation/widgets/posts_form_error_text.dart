import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';

class PostsFormErrorText extends StatelessWidget {
  const PostsFormErrorText({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        fontSize: 14,
        height: 1.4,
        color: PostsUiConstants.errorColor,
      ),
    );
  }
}
