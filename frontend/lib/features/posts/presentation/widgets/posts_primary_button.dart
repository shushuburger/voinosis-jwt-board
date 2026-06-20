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
  });

  final String label;
  final VoidCallback? onPressed;
  final Size minimumSize;
  final EdgeInsetsGeometry? padding;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: PostsUiConstants.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: minimumSize,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(PostsUiConstants.buttonBorderRadius),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
