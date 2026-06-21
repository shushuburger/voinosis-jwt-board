import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/shared/exceptions/api_request_exception.dart';
import 'package:voinosis_jwt_board/features/posts/data/posts_repository_provider.dart';
import 'package:voinosis_jwt_board/features/posts/model/create_post_request.dart';
import 'package:voinosis_jwt_board/features/posts/provider/create_post_state.dart';

class CreatePostNotifier extends Notifier<CreatePostState> {
  @override
  CreatePostState build() => const CreatePostState();

  void reset() {
    state = const CreatePostState();
  }

  Future<void> submitPost({
    required String title,
    required String content,
  }) async {
    if (state.isSubmitting) {
      return;
    }

    state = state.copyWith(
      isSubmitting: true,
      isSuccess: false,
      clearErrorMessage: true,
    );

    try {
      final repository = ref.read(postsRepositoryProvider);
      await repository.createPost(
        CreatePostRequest(
          title: title.trim(),
          content: content.trim(),
        ),
      );

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
      );
    } on ApiRequestException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
      );
    }
  }
}
