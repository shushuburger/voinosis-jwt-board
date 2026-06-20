import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_validators.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_form_card.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_link_prompt.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_text_field.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
    required this.onLoginPressed,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AuthPageHeader(
          title: AuthUiText.appTitle,
          subtitle: AuthUiText.signupSubtitle,
        ),
        const SizedBox(height: 40),
        AuthFormCard(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AuthUiText.signupCardTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AuthUiConstants.titleColor,
                  ),
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  label: AuthUiText.emailLabel,
                  controller: emailController,
                  hintText: AuthUiText.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  validator: AuthValidators.email,
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  label: AuthUiText.passwordLabel,
                  controller: passwordController,
                  hintText: AuthUiText.passwordHint,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  onFieldSubmitted: (_) => onSubmit(),
                  validator: AuthValidators.password,
                ),
                const SizedBox(height: 28),
                AuthPrimaryButton(
                  label: AuthUiText.signupButton,
                  isLoading: isLoading,
                  onPressed: onSubmit,
                ),
                const SizedBox(height: 20),
                AuthLinkPrompt(
                  prompt: AuthUiText.loginPrompt,
                  linkLabel: AuthUiText.loginLink,
                  enabled: !isLoading,
                  onLinkPressed: onLoginPressed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
