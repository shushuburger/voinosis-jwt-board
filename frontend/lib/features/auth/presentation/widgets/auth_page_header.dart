import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';

class AuthPageHeader extends StatelessWidget {
  const AuthPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AuthUiConstants.pageHeaderTitleFontSize,
            fontWeight: FontWeight.w700,
            color: AuthUiConstants.titleColor,
            height: AuthUiConstants.pageHeaderTitleLineHeight,
          ),
        ),
        const SizedBox(height: AuthUiConstants.headerSubtitleSpacing),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AuthUiConstants.pageHeaderSubtitleFontSize,
            color: AuthUiConstants.subtitleColor,
            height: AuthUiConstants.pageHeaderSubtitleLineHeight,
          ),
        ),
      ],
    );
  }
}
