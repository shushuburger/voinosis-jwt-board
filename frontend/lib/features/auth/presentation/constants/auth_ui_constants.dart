import 'package:flutter/material.dart';

abstract final class AuthUiConstants {
  static const backgroundColor = Color(0xFFF5F6F8);
  static const primaryColor = Color(0xFF7A2940);
  static const titleColor = Color(0xFFB64B6F);
  static const subtitleColor = Color(0xFF6B7280);
  static const labelColor = Color(0xFF374151);
  static const borderColor = Color(0xFFE5E7EB);
  static const hintColor = Color(0xFF9CA3AF);

  static const maxFormWidth = 420.0;
  static const fieldBorderRadius = 8.0;
  static const cardBorderRadius = 16.0;
  static const buttonHeight = 48.0;

  static const pageHorizontalPadding = 24.0;
  static const pageVerticalPadding = 32.0;
  static const cardPadding = EdgeInsets.fromLTRB(28, 28, 28, 24);
}

abstract final class AuthUiText {
  static const appTitle = 'JWT 익명 게시판';
  static const loginSubtitle = '로그인하고 게시글을 확인해보세요.';
  static const loginCardTitle = '로그인';
  static const emailLabel = '이메일';
  static const passwordLabel = '비밀번호';
  static const emailHint = 'example@email.com';
  static const passwordHint = '8자리 이상 입력해주세요.';
  static const loginButton = '로그인';
  static const signupPrompt = '아직 계정이 없으신가요? ';
  static const signupLink = '회원가입';
}
