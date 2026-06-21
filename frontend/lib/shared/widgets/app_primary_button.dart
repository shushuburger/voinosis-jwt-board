import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/shared/constants/app_ui_constants.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.minimumSize = const Size(120, 40),
    this.padding,
    this.fontSize = AppUiConstants.buttonFontSize,
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
        backgroundColor: AppUiConstants.primaryColor,
        disabledBackgroundColor: AppUiConstants.primaryColor.withValues(
          alpha: AppUiConstants.buttonDisabledAlpha,
        ),
        foregroundColor: Colors.white,
        minimumSize: minimumSize,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppUiConstants.fieldBorderRadius),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              width: AppUiConstants.buttonLoadingIndicatorSize,
              height: AppUiConstants.buttonLoadingIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: AppUiConstants.buttonLoadingStrokeWidth,
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
