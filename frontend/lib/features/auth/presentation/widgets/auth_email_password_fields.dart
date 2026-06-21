import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_text.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_validators.dart';
import 'package:voinosis_jwt_board/shared/widgets/labeled_text_field.dart';

class AuthEmailPasswordFields extends StatelessWidget {
  const AuthEmailPasswordFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
    this.emailError,
    this.passwordError,
    this.onEmailChanged,
    this.onPasswordChanged,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final String? emailError;
  final String? passwordError;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledTextField(
          label: AuthUiText.emailLabel,
          controller: emailController,
          hintText: AuthUiText.emailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
          validator: (value) => emailError ?? AuthValidators.email(value),
          onChanged: onEmailChanged,
        ),
        const SizedBox(height: AuthUiConstants.emailPasswordSpacing),
        LabeledTextField(
          label: AuthUiText.passwordLabel,
          controller: passwordController,
          hintText: AuthUiText.passwordHint,
          obscureText: true,
          textInputAction: TextInputAction.done,
          enabled: !isLoading,
          onFieldSubmitted: (_) => onSubmit(),
          validator: (value) => passwordError ?? AuthValidators.password(value),
          onChanged: onPasswordChanged,
        ),
      ],
    );
  }
}
