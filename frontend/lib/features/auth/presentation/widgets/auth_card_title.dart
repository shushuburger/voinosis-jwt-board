import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';

class AuthCardTitle extends StatelessWidget {
  const AuthCardTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: AuthUiConstants.titleFontSize,
        fontWeight: FontWeight.w700,
        color: AuthUiConstants.titleColor,
      ),
    );
  }
}
