import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';

abstract final class PostsUiConstants {
  static const backgroundColor = AuthUiConstants.backgroundColor;
  static const primaryColor = AuthUiConstants.primaryColor;
  static const titleColor = AuthUiConstants.titleColor;
  static const subtitleColor = AuthUiConstants.subtitleColor;
  static const borderColor = AuthUiConstants.borderColor;
  static const headingColor = Color(0xFF111827);
  static const errorColor = Color(0xFFDC2626);
  static const appBarBackgroundColor = Colors.white;
  static const cardBackgroundColor = Colors.white;

  static const pageHorizontalPadding = 16.0;
  static const listVerticalPadding = 16.0;
  static const cardBorderRadius = AuthUiConstants.cardBorderRadius;
  static const buttonBorderRadius = AuthUiConstants.fieldBorderRadius;
  static const cardSpacing = 12.0;
  static const appBarActionPadding = 16.0;
  static const appBarActionSpacing = 8.0;
  static const stateViewHorizontalPadding = 32.0;

  static const authButtonSize = Size(88, 36);
  static const createButtonSize = Size(96, 36);
  static const createButtonPadding = EdgeInsets.symmetric(horizontal: 16);
  static const retryButtonSize = Size(120, 40);
  static const scrollLoadThreshold = 200.0;

  static const stateIconTextSpacing = 16.0;
  static const stateTitleSubtitleSpacing = 8.0;
  static const stateMessageButtonSpacing = 20.0;
  static const stateBodyFontSize = 14.0;
  static const stateTitleFontSize = 18.0;
  static const appBarTitleFontSize = 20.0;
  static const compactBodyFontSize = 13.0;
  static const paginationErrorSpacing = 8.0;
  static const createButtonFontSize = 14.0;
}
