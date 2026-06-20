import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/create_post_ui_text.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';

class PostsCreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PostsCreateAppBar({
    super.key,
    required this.onBackPressed,
  });

  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PostsUiConstants.appBarBackgroundColor,
      foregroundColor: PostsUiConstants.headingColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed,
      ),
      title: const Text(
        CreatePostUiText.screenTitle,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
