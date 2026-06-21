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

    _revalidateForm(formKey);
  }

  static void clearFieldError({
    required GlobalKey<FormState> formKey,
    required VoidCallback clearError,
  }) {
    clearError();
    _revalidateForm(formKey);
  }

  static void _revalidateForm(GlobalKey<FormState> formKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      formKey.currentState?.validate();
    });
  }
}
