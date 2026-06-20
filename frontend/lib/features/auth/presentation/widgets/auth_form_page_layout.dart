import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';

class AuthFormPageLayout extends StatelessWidget {
  const AuthFormPageLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthUiConstants.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AuthUiConstants.pageHorizontalPadding,
              vertical: AuthUiConstants.pageVerticalPadding,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AuthUiConstants.maxFormWidth,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
