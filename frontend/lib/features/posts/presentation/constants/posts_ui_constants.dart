import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/shared/constants/app_ui_constants.dart';

abstract final class PostsUiConstants {
  static const backgroundColor = AppUiConstants.backgroundColor;
  static const primaryColor = AppUiConstants.primaryColor;
  static const titleColor = AppUiConstants.titleColor;
  static const subtitleColor = AppUiConstants.subtitleColor;
  static const borderColor = AppUiConstants.borderColor;
  static const headingColor = AppUiConstants.headingColor;
  static const errorColor = AppUiConstants.errorColor;
  static const appBarBackgroundColor = Colors.white;
  static const cardBackgroundColor = Colors.white;

  static const pageHorizontalPadding = 16.0;
  static const listVerticalPadding = 16.0;
  static const cardBorderRadius = AppUiConstants.cardBorderRadius;
  static const cardSpacing = 12.0;
  static const appBarActionPadding = 16.0;
  static const appBarActionSpacing = 8.0;
  static const stateViewHorizontalPadding = 32.0;

  static const cardPadding = 16.0;
  static const cardTitleFontSize = 16.0;
  static const cardContentFontSize = AppUiConstants.bodyFontSize;
  static const cardDateFontSize = 12.0;
  static const cardTitleContentSpacing = 8.0;
  static const cardContentDateSpacing = 12.0;
  static const cardContentLineHeight = 1.5;
  static const cardShadowBlurRadius = 12.0;
  static const cardShadowOffsetY = 4.0;
  static const cardShadowAlpha = 0.04;

  static const authButtonSize = Size(88, 36);
  static const createButtonSize = Size(96, 36);
  static const createButtonPadding = EdgeInsets.symmetric(horizontal: 16);
  static const retryButtonSize = Size(120, 40);
  static const scrollLoadThreshold = 200.0;

  static const stateIconTextSpacing = 16.0;
  static const stateTitleSubtitleSpacing = 8.0;
  static const stateMessageButtonSpacing = 20.0;
  static const stateBodyFontSize = AppUiConstants.bodyFontSize;
  static const stateTitleFontSize = 18.0;
  static const appBarTitleFontSize = 20.0;
  static const compactBodyFontSize = 13.0;
  static const paginationErrorSpacing = 8.0;
  static const createButtonFontSize = 14.0;
}
