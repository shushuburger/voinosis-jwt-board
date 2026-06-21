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
    final isCompact =
        MediaQuery.sizeOf(context).width < PostsUiConstants.appBarCompactBreakpoint;

    return Padding(
      padding: EdgeInsets.only(
        right: isCompact
            ? PostsUiConstants.compactAppBarActionPadding
            : PostsUiConstants.appBarActionSpacing,
      ),
      child: AppPrimaryButton(
        label: label,
        onPressed: onPressed,
        minimumSize: isCompact
            ? PostsUiConstants.compactAuthButtonSize
            : PostsUiConstants.authButtonSize,
        padding: isCompact
            ? const EdgeInsets.symmetric(horizontal: 12)
            : PostsUiConstants.createButtonPadding,
        fontSize: isCompact
            ? PostsUiConstants.compactButtonFontSize
            : PostsUiConstants.createButtonFontSize,
      ),
    );
  }
}
