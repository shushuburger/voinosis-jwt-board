import 'package:flutter/material.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/create_post_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/create_post_ui_text.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/utils/create_post_validators.dart';
import 'package:voinosis_jwt_board/shared/widgets/app_primary_button.dart';
import 'package:voinosis_jwt_board/shared/widgets/labeled_text_field.dart';

class CreatePostForm extends StatelessWidget {
  const CreatePostForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.contentController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledTextField(
            label: CreatePostUiText.titleLabel,
            controller: titleController,
            hintText: CreatePostUiText.titleHint,
            textInputAction: TextInputAction.next,
            enabled: !isSubmitting,
            validator: CreatePostValidators.title,
          ),
          const SizedBox(height: CreatePostUiConstants.fieldSpacing),
          LabeledTextField(
            label: CreatePostUiText.contentLabel,
            controller: contentController,
            hintText: CreatePostUiText.contentHint,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: CreatePostUiConstants.contentMinLines,
            maxLines: CreatePostUiConstants.contentMaxLines,
            enabled: !isSubmitting,
            validator: CreatePostValidators.content,
          ),
          const SizedBox(height: CreatePostUiConstants.submitSpacing),
          AppPrimaryButton(
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
      ),
    );
  }
}
