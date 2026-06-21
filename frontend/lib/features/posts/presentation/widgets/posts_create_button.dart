import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_text.dart';
import 'package:voinosis_jwt_board/shared/constants/app_ui_constants.dart';
import 'package:voinosis_jwt_board/shared/widgets/app_primary_button.dart';

class PostsCreateButton extends StatelessWidget {
  const PostsCreateButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isCompact =
        MediaQuery.sizeOf(context).width < PostsUiConstants.appBarCompactBreakpoint;

    if (isCompact) {
      return Padding(
        padding: const EdgeInsets.only(
          right: PostsUiConstants.compactAppBarActionPadding,
        ),
        child: Tooltip(
          message: PostsUiText.createButton,
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: PostsUiConstants.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: PostsUiConstants.compactCreateButtonSize,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppUiConstants.fieldBorderRadius,
                ),
              ),
              elevation: 0,
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: PostsUiConstants.compactCreateIconSize,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: PostsUiConstants.appBarActionPadding),
      child: AppPrimaryButton(
        label: PostsUiText.createButton,
        onPressed: onPressed,
        minimumSize: PostsUiConstants.createButtonSize,
        padding: PostsUiConstants.createButtonPadding,
        fontSize: PostsUiConstants.createButtonFontSize,
      ),
    );
  }
}
