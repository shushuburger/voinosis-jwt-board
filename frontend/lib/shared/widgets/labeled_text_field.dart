import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/shared/constants/app_ui_constants.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.minLines,
    this.maxLines,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppUiConstants.labelFontSize,
            fontWeight: FontWeight.w600,
            color: AppUiConstants.labelColor,
          ),
        ),
        const SizedBox(height: AppUiConstants.fieldLabelSpacing),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          enabled: enabled,
          minLines: obscureText ? 1 : minLines,
          maxLines: obscureText ? 1 : maxLines,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          decoration: inputDecoration(hintText),
        ),
      ],
    );
  }

  static InputDecoration inputDecoration(String hintText) {
    final borderRadius =
        BorderRadius.circular(AppUiConstants.fieldBorderRadius);

    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: AppUiConstants.hintColor,
        fontSize: AppUiConstants.bodyFontSize,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppUiConstants.fieldContentPaddingHorizontal,
        vertical: AppUiConstants.fieldContentPaddingVertical,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppUiConstants.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppUiConstants.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(
          color: AppUiConstants.primaryColor,
          width: AppUiConstants.fieldFocusedBorderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
