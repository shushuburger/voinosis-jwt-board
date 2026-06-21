import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_text.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_card_title.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_email_password_fields.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_form_card.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_link_prompt.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:voinosis_jwt_board/shared/widgets/app_primary_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
    required this.onSignupPressed,
    this.emailError,
    this.passwordError,
    this.onEmailChanged,
    this.onPasswordChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onSignupPressed;
  final String? emailError;
  final String? passwordError;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AuthPageHeader(
          title: AuthUiText.appTitle,
          subtitle: AuthUiText.loginSubtitle,
        ),
        const SizedBox(height: AuthUiConstants.formOuterSpacing),
        AuthFormCard(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthCardTitle(title: AuthUiText.loginCardTitle),
                const SizedBox(height: AuthUiConstants.cardTitleFieldSpacing),
                AuthEmailPasswordFields(
                  emailController: emailController,
                  passwordController: passwordController,
                  isLoading: isLoading,
                  onSubmit: onSubmit,
                  emailError: emailError,
                  passwordError: passwordError,
                  onEmailChanged: onEmailChanged,
                  onPasswordChanged: onPasswordChanged,
                ),
                const SizedBox(height: AuthUiConstants.fieldsSubmitSpacing),
                AppPrimaryButton(
                  label: AuthUiText.loginButton,
                  isLoading: isLoading,
                  expand: true,
                  minimumSize: const Size(
                    double.infinity,
                    AuthUiConstants.buttonHeight,
                  ),
                  onPressed: onSubmit,
                ),
                const SizedBox(height: AuthUiConstants.submitLinkSpacing),
                AuthLinkPrompt(
                  prompt: AuthUiText.signupPrompt,
                  linkLabel: AuthUiText.signupLink,
                  enabled: !isLoading,
                  onLinkPressed: onSignupPressed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
