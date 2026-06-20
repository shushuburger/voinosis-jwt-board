import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';

abstract final class PostsUiConstants {
  static const backgroundColor = AuthUiConstants.backgroundColor;
  static const primaryColor = AuthUiConstants.primaryColor;
  static const titleColor = AuthUiConstants.titleColor;
  static const subtitleColor = AuthUiConstants.subtitleColor;
  static const borderColor = AuthUiConstants.borderColor;

  static const pageHorizontalPadding = 16.0;
  static const listVerticalPadding = 16.0;
  static const cardBorderRadius = AuthUiConstants.cardBorderRadius;
  static const cardSpacing = 12.0;
}

abstract final class PostsUiText {
  static const screenTitle = 'Posts';
  static const createButton = 'Create';
  static const emptyTitle = '게시글이 없습니다';
  static const emptySubtitle = '첫 번째 게시글을 작성해보세요.';
  static const retryButton = '다시 시도';
  static const authorPrefix = '작성자';
}
