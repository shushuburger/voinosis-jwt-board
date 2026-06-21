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
  }) {
    if (next.status != AuthStatus.error) {
      return;
    }

    if (next.emailError == null && next.passwordError == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formKey.currentState?.validate();
    });
  }
}
