import 'package:voinosis_jwt_board/features/posts/model/post_model.dart';

class PostsState {
  const PostsState({
    this.posts = const [],
    this.currentPage = 0,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isPaginationLoading = false,
    this.errorMessage,
    this.paginationErrorMessage,
    this.hasReachedEnd = false,
  });

  final List<PostModel> posts;
  final int currentPage;
  final bool isLoading;
  final bool isRefreshing;
  final bool isPaginationLoading;
  final String? errorMessage;
  final String? paginationErrorMessage;
  final bool hasReachedEnd;

  bool get isEmpty =>
      !isLoading &&
      errorMessage == null &&
      posts.isEmpty &&
      currentPage > 0;

  PostsState copyWith({
    List<PostModel>? posts,
    int? currentPage,
    bool? isLoading,
    bool? isRefreshing,
    bool? isPaginationLoading,
    String? errorMessage,
    String? paginationErrorMessage,
    bool? hasReachedEnd,
    bool clearErrorMessage = false,
    bool clearPaginationErrorMessage = false,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      paginationErrorMessage: clearPaginationErrorMessage
          ? null
          : (paginationErrorMessage ?? this.paginationErrorMessage),
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}
