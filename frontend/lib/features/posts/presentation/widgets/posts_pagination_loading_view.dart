import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';

class PostsPaginationLoadingView extends StatelessWidget {
  const PostsPaginationLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: PostsUiConstants.primaryColor,
          ),
        ),
      ),
    );
  }
}
