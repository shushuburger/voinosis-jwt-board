import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';

class AuthLinkPrompt extends StatelessWidget {
  const AuthLinkPrompt({
    super.key,
    required this.prompt,
    required this.linkLabel,
    required this.onLinkPressed,
    this.enabled = true,
  });

  final String prompt;
  final String linkLabel;
  final VoidCallback onLinkPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: enabled ? onLinkPressed : null,
        style: TextButton.styleFrom(
          foregroundColor: AuthUiConstants.subtitleColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: Text.rich(
          TextSpan(
            text: prompt,
            children: [
              TextSpan(
                text: linkLabel,
                style: const TextStyle(
                  color: AuthUiConstants.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
