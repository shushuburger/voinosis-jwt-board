import 'package:voinosis_jwt_board/features/posts/presentation/constants/create_post_validation_messages.dart';

class CreatePostValidators {
  CreatePostValidators._();

  static String? title(String? value) {
    if ((value?.trim() ?? '').isEmpty) {
      return CreatePostValidationMessages.titleRequired;
    }

    return null;
  }

  static String? content(String? value) {
    if ((value?.trim() ?? '').isEmpty) {
      return CreatePostValidationMessages.contentRequired;
    }

    return null;
  }
}
