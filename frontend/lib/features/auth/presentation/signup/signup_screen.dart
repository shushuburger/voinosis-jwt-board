import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/signup/signup_actions.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/signup/signup_form.dart';
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
    final isLoading = ref.watch(authProvider).status == AuthStatus.loading;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!mounted) {
        return;
      }

      SignupActions.handleAuthStateChange(
        context: context,
        previous: previous,
        next: next,
      );
    });

    return Scaffold(
      backgroundColor: AuthUiConstants.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AuthUiConstants.pageHorizontalPadding,
              vertical: AuthUiConstants.pageVerticalPadding,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AuthUiConstants.maxFormWidth,
              ),
              child: SignupForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                isLoading: isLoading,
                onSubmit: _handleSignup,
                onLoginPressed: () => context.go(RoutePaths.login),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
