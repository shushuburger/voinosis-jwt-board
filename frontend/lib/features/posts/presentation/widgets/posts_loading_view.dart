import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';

class PostsLoadingView extends StatelessWidget {
  const PostsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: PostsUiConstants.primaryColor,
      ),
    );
  }
}
