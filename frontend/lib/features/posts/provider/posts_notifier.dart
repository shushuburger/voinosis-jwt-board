import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/posts/data/posts_repository.dart';
import 'package:voinosis_jwt_board/features/posts/data/posts_repository_provider.dart';
import 'package:voinosis_jwt_board/features/posts/model/posts_response.dart';
import 'package:voinosis_jwt_board/features/posts/provider/posts_state.dart';

class PostsNotifier extends Notifier<PostsState> {
  static const _pageLimit = 10;

  @override
  PostsState build() => const PostsState();

  Future<void> fetchInitialPosts() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
      clearPaginationErrorMessage: true,
      hasReachedEnd: false,
    );

    try {
      final response = await _fetchPage(1);

      state = PostsState(
        posts: response.data,
        currentPage: response.meta.page,
        hasReachedEnd: _hasReachedEnd(response.meta.page, response.meta.lastPage),
      );
    } on PostsFetchException catch (error) {
      state = PostsState(errorMessage: error.message);
    }
  }

  Future<void> fetchNextPage() async {
    if (state.isPaginationLoading ||
        state.hasReachedEnd ||
        state.isLoading ||
        state.currentPage == 0) {
      return;
    }

    state = state.copyWith(
      isPaginationLoading: true,
      clearPaginationErrorMessage: true,
    );

    try {
      final nextPage = state.currentPage + 1;
      final response = await _fetchPage(nextPage);

      state = state.copyWith(
        posts: [...state.posts, ...response.data],
        currentPage: response.meta.page,
        isPaginationLoading: false,
        hasReachedEnd: _hasReachedEnd(response.meta.page, response.meta.lastPage),
      );
    } on PostsFetchException catch (error) {
      state = state.copyWith(
        isPaginationLoading: false,
        paginationErrorMessage: error.message,
      );
    }
  }

  Future<void> refreshPosts() async {
    if (state.isRefreshing || state.isLoading) {
      return;
    }

    state = state.copyWith(
      isRefreshing: true,
      clearPaginationErrorMessage: true,
    );

    try {
      final response = await _fetchPage(1);

      state = PostsState(
        posts: response.data,
        currentPage: response.meta.page,
        hasReachedEnd: _hasReachedEnd(response.meta.page, response.meta.lastPage),
      );
    } on PostsFetchException {
      state = state.copyWith(isRefreshing: false);
      rethrow;
    }
  }

  Future<PostsResponse> _fetchPage(int page) {
    final repository = ref.read(postsRepositoryProvider);
    return repository.fetchPosts(page: page, limit: _pageLimit);
  }

  bool _hasReachedEnd(int page, int lastPage) => page >= lastPage;
}
