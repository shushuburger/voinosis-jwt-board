import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';

class PostsFormPageLayout extends StatelessWidget {
  const PostsFormPageLayout({
    super.key,
    required this.appBar,
    required this.child,
  });

  final PreferredSizeWidget appBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PostsUiConstants.backgroundColor,
      appBar: appBar,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: PostsUiConstants.pageHorizontalPadding,
          vertical: PostsUiConstants.listVerticalPadding,
        ),
        child: child,
      ),
    );
  }
}
