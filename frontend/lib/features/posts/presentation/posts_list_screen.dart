import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/post_card.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_empty_view.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_error_view.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_loading_view.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_pagination_error_view.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_pagination_loading_view.dart';
import 'package:voinosis_jwt_board/features/posts/provider/posts_provider.dart';
import 'package:voinosis_jwt_board/features/posts/provider/posts_state.dart';

class PostsListScreen extends ConsumerStatefulWidget {
  const PostsListScreen({super.key});

  @override
  ConsumerState<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends ConsumerState<PostsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchInitialPosts);
  }

  Future<void> _fetchInitialPosts() {
    return ref.read(postsProvider.notifier).fetchInitialPosts();
  }

  Future<void> _fetchNextPage() {
    return ref.read(postsProvider.notifier).fetchNextPage();
  }

  void _onCreatePressed() {
    // TODO(Issue #9): auth 확인 후 /posts/create 또는 /login 이동 (Step 7)
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: PostsUiConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          PostsUiText.screenTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton(
              onPressed: _onCreatePressed,
              style: FilledButton.styleFrom(
                backgroundColor: PostsUiConstants.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(72, 36),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                PostsUiText.createButton,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _PostsBody(
        state: postsState,
        onRetryInitial: _fetchInitialPosts,
        onRetryPagination: _fetchNextPage,
      ),
    );
  }
}

class _PostsBody extends StatelessWidget {
  const _PostsBody({
    required this.state,
    required this.onRetryInitial,
    required this.onRetryPagination,
  });

  final PostsState state;
  final VoidCallback onRetryInitial;
  final VoidCallback onRetryPagination;

  @override
  Widget build(BuildContext context) {
    if (_showInitialLoading) {
      return const PostsLoadingView();
    }

    if (state.errorMessage != null && state.posts.isEmpty) {
      return PostsErrorView(
        message: state.errorMessage!,
        onRetry: onRetryInitial,
      );
    }

    if (state.isEmpty) {
      return const PostsEmptyView();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        PostsUiConstants.pageHorizontalPadding,
        PostsUiConstants.listVerticalPadding,
        PostsUiConstants.pageHorizontalPadding,
        PostsUiConstants.listVerticalPadding,
      ),
      itemCount: _itemCount,
      separatorBuilder: (_, __) =>
          const SizedBox(height: PostsUiConstants.cardSpacing),
      itemBuilder: (context, index) {
        if (index < state.posts.length) {
          return PostCard(post: state.posts[index]);
        }

        if (state.isPaginationLoading) {
          return const PostsPaginationLoadingView();
        }

        if (state.paginationErrorMessage != null) {
          return PostsPaginationErrorView(
            message: state.paginationErrorMessage!,
            onRetry: onRetryPagination,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  bool get _showInitialLoading =>
      state.posts.isEmpty &&
      state.errorMessage == null &&
      (state.isLoading || state.currentPage == 0);

  int get _itemCount {
    var count = state.posts.length;

    if (state.isPaginationLoading || state.paginationErrorMessage != null) {
      count += 1;
    }

    return count;
  }
}
