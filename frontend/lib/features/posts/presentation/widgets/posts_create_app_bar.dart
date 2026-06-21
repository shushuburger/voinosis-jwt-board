import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/create_post_ui_text.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_app_bar.dart';

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
    return PostsAppBar(
      title: CreatePostUiText.screenTitle,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed,
      ),
    );
  }
}
