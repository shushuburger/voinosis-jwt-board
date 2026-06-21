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
      centerTitle: false,
      titleSpacing: leading == null ? PostsUiConstants.pageHorizontalPadding : 0,
      leading: leading,
      title: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: PostsUiConstants.appBarTitleFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      actions: actions,
    );
  }
}
