import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';

class AuthFormActions {
  AuthFormActions._();

  static Future<void> submitIfValid({
    required GlobalKey<FormState> formKey,
    required Future<void> Function() action,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    await action();
  }

  static void applyFieldErrors({
    required GlobalKey<FormState> formKey,
    required AuthState next,
    required void Function(String? emailError, String? passwordError) onApply,
  }) {
    if (next.status != AuthStatus.error) {
      return;
    }

    if (next.emailError == null && next.passwordError == null) {
      return;
    }

    onApply(next.emailError, next.passwordError);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formKey.currentState?.validate();
    });
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message);
  }
}
