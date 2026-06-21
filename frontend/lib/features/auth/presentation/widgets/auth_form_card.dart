import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AuthUiConstants.cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AuthUiConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: AuthUiConstants.formCardShadowAlpha,
            ),
            blurRadius: AuthUiConstants.formCardShadowBlurRadius,
            offset: const Offset(0, AuthUiConstants.formCardShadowOffsetY),
          ),
        ],
      ),
      child: child,
    );
  }
}
