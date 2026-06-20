class CreatePostState {
  const CreatePostState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  CreatePostState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CreatePostState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
