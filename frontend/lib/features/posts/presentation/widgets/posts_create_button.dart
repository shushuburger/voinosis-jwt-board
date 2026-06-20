import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_primary_button.dart';

class PostsCreateButton extends StatelessWidget {
  const PostsCreateButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: PostsUiConstants.appBarActionPadding),
      child: PostsPrimaryButton(
        label: PostsUiText.createButton,
        onPressed: onPressed,
        minimumSize: PostsUiConstants.createButtonSize,
        padding: PostsUiConstants.createButtonPadding,
        fontSize: 14,
      ),
    );
  }
}
