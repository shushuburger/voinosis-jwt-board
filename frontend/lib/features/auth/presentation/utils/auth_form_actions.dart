import 'package:flutter/material.dart';

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

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}
