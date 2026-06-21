import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_form_actions.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_provider.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';

class SignupActions {
  SignupActions._();

  static Future<void> submit({
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    await AuthFormActions.submitIfValid(
      formKey: formKey,
      action: () => ref.read(authProvider.notifier).signup(email, password),
    );
  }

  static void handleAuthStateChange({
    required BuildContext context,
    required AuthState? previous,
    required AuthState next,
  }) {
    if (previous?.status == AuthStatus.loading &&
        next.status == AuthStatus.unauthenticated) {
      context.go(RoutePaths.login);
    }
  }
}
