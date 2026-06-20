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
  static const stateViewHorizontalPadding = 32.0;

  static const createButtonSize = Size(72, 36);
  static const createButtonPadding = EdgeInsets.symmetric(horizontal: 16);
  static const retryButtonSize = Size(120, 40);
  static const scrollLoadThreshold = 200.0;
}

abstract final class PostsUiText {
  static const screenTitle = 'Posts';
  static const createButton = 'Create';
  static const emptyTitle = '게시글이 없습니다';
  static const emptySubtitle = '첫 번째 게시글을 작성해보세요.';
  static const retryButton = '다시 시도';
  static const authorPrefix = '작성자';
  static const createScreenTitle = 'Create Post';
  static const createPlaceholderMessage =
      '게시글 작성 화면은 Issue #9에서 구현 예정입니다.';
}
