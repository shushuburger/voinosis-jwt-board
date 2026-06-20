import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_error_message.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_provider.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';

class LoginActions {
  LoginActions._();

  static Future<void> submit({
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    await ref.read(authProvider.notifier).login(email, password);
  }

  static void handleAuthStateChange({
    required BuildContext context,
    required AuthState next,
  }) {
    if (next.status == AuthStatus.authenticated) {
      context.go(RoutePaths.home);
      return;
    }

    if (next.status == AuthStatus.error && next.errorMessage != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(AuthErrorMessage.forLogin(next.errorMessage!)),
          ),
        );
    }
  }
}
