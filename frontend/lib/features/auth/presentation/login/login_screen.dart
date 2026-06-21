import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/login/login_actions.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/login/login_form.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_form_actions.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_form_page_layout.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_provider.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    await LoginActions.submit(
      ref: ref,
      formKey: _formKey,
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!mounted) {
        return;
      }

      AuthFormActions.applyFieldErrors(formKey: _formKey, next: next);
      LoginActions.handleAuthStateChange(context: context, next: next);
    });

    return AuthFormPageLayout(
      child: LoginForm(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        isLoading: isLoading,
        onSubmit: _handleLogin,
        onSignupPressed: () => context.go(RoutePaths.signup),
        emailError: authState.emailError,
        passwordError: authState.passwordError,
        onEmailChanged: (_) => AuthFormActions.clearFieldError(
          formKey: _formKey,
          clearError: ref.read(authProvider.notifier).clearEmailError,
        ),
        onPasswordChanged: (_) => AuthFormActions.clearFieldError(
          formKey: _formKey,
          clearError: ref.read(authProvider.notifier).clearPasswordError,
        ),
      ),
    );
  }
}
