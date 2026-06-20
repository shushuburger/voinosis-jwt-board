import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/create_post_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/create_post_ui_text.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_form_error_text.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_primary_button.dart';

class CreatePostForm extends StatelessWidget {
  const CreatePostForm({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.isSubmitting,
    required this.onSubmit,
    this.errorMessage,
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: CreatePostUiText.titleLabel,
          controller: titleController,
          hintText: CreatePostUiText.titleHint,
          textInputAction: TextInputAction.next,
          enabled: !isSubmitting,
        ),
        const SizedBox(height: CreatePostUiConstants.fieldSpacing),
        AuthTextField(
          label: CreatePostUiText.contentLabel,
          controller: contentController,
          hintText: CreatePostUiText.contentHint,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          minLines: CreatePostUiConstants.contentMinLines,
          maxLines: CreatePostUiConstants.contentMaxLines,
          enabled: !isSubmitting,
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: CreatePostUiConstants.errorSpacing),
          PostsFormErrorText(message: errorMessage!),
        ],
        const SizedBox(height: CreatePostUiConstants.submitSpacing),
        PostsPrimaryButton(
          label: CreatePostUiText.saveButton,
          isLoading: isSubmitting,
          expand: true,
          minimumSize: const Size(
            double.infinity,
            CreatePostUiConstants.submitButtonHeight,
          ),
          onPressed: onSubmit,
        ),
      ],
    );
  }
}
