import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/constants/auth_ui_constants.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_validators.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_text_field.dart';

class AuthEmailPasswordFields extends StatelessWidget {
  const AuthEmailPasswordFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}
