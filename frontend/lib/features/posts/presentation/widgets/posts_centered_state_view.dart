import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';

class PostsCenteredStateView extends StatelessWidget {
  const PostsCenteredStateView({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PostsUiConstants.stateViewHorizontalPadding,
        ),
        child: child,
      ),
    );
  }
}
