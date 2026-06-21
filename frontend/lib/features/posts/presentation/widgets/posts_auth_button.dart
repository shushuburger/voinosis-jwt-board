import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/shared/widgets/app_primary_button.dart';

class PostsAuthButton extends StatelessWidget {
  const PostsAuthButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: PostsUiConstants.appBarActionSpacing,
      ),
      child: AppPrimaryButton(
        label: label,
        onPressed: onPressed,
        minimumSize: PostsUiConstants.authButtonSize,
        padding: PostsUiConstants.createButtonPadding,
        fontSize: PostsUiConstants.createButtonFontSize,
      ),
    );
  }
}
