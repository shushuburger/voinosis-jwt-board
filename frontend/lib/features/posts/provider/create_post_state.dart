class CreatePostState {
  const CreatePostState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.isSessionExpired = false,
  });

  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final bool isSessionExpired;

  CreatePostState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool? isSessionExpired,
    bool clearErrorMessage = false,
    bool clearSessionExpired = false,
  }) {
    return CreatePostState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isSessionExpired:
          clearSessionExpired ? false : (isSessionExpired ?? this.isSessionExpired),
    );
  }
}
