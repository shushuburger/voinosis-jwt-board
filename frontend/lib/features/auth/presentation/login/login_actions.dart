import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_form_actions.dart';
import 'package:voinosis_jwt_board/shared/utils/snackbar_utils.dart';
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
    await AuthFormActions.submitIfValid(
      formKey: formKey,
      action: () => ref.read(authProvider.notifier).login(email, password),
    );
  }

  static void handleAuthStateChange({
    required BuildContext context,
    required AuthState next,
  }) {
    if (next.status == AuthStatus.authenticated) {
      context.go(RoutePaths.home);
      return;
    }

    if (next.status == AuthStatus.error &&
        next.emailError == null &&
        next.passwordError == null &&
        next.errorMessage != null) {
      SnackBarUtils.showError(context, next.errorMessage!);
    }
  }
}
