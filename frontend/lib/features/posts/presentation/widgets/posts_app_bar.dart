import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';

class PostsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PostsAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PostsUiConstants.appBarBackgroundColor,
      foregroundColor: PostsUiConstants.headingColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: PostsUiConstants.appBarTitleFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
    );
  }
}
