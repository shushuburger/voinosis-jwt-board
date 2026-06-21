import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/signup/signup_actions.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/signup/signup_form.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_form_actions.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_form_page_layout.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_provider.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    FocusScope.of(context).unfocus();

    await SignupActions.submit(
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
      SignupActions.handleAuthStateChange(
        context: context,
        previous: previous,
        next: next,
      );
    });

    return AuthFormPageLayout(
      child: SignupForm(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        isLoading: isLoading,
        onSubmit: _handleSignup,
        onLoginPressed: () => context.go(RoutePaths.login),
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
