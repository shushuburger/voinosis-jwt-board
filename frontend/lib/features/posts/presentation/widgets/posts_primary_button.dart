import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';

class PostsPrimaryButton extends StatelessWidget {
  const PostsPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.minimumSize = const Size(120, 40),
    this.padding,
    this.fontSize = 16,
    this.isLoading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Size minimumSize;
  final EdgeInsetsGeometry? padding;
  final double fontSize;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: PostsUiConstants.primaryColor,
        disabledBackgroundColor:
            PostsUiConstants.primaryColor.withValues(alpha: 0.6),
        foregroundColor: Colors.white,
        minimumSize: minimumSize,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(PostsUiConstants.buttonBorderRadius),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
    );

    if (expand) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
