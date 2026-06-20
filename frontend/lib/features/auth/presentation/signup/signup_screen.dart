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
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    await SignupActions.submit(
      ref: ref,
      formKey: _formKey,
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _clearEmailError(String _) {
    if (_emailError == null) {
      return;
    }

    setState(() => _emailError = null);
  }

  void _clearPasswordError(String _) {
    if (_passwordError == null) {
      return;
    }

    setState(() => _passwordError = null);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).status == AuthStatus.loading;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!mounted) {
        return;
      }

      AuthFormActions.applyFieldErrors(
        formKey: _formKey,
        next: next,
        onApply: (emailError, passwordError) {
          setState(() {
            _emailError = emailError;
            _passwordError = passwordError;
          });
        },
      );

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
        emailError: _emailError,
        passwordError: _passwordError,
        onEmailChanged: _clearEmailError,
        onPasswordChanged: _clearPasswordError,
      ),
    );
  }
}
