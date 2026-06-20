import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/posts_actions.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/post_card.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_create_button.dart';
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
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    Future.microtask(() => PostsActions.fetchInitialPosts(ref));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    const threshold = PostsUiConstants.scrollLoadThreshold;

    if (position.pixels >= position.maxScrollExtent - threshold) {
      PostsActions.fetchNextPage(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: PostsUiConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: PostsUiConstants.appBarBackgroundColor,
        foregroundColor: PostsUiConstants.headingColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          PostsUiText.screenTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          PostsCreateButton(onPressed: PostsActions.onCreatePressed),
        ],
      ),
      body: _PostsBody(
        state: postsState,
        scrollController: _scrollController,
        onRetryInitial: () => PostsActions.fetchInitialPosts(ref),
        onRetryPagination: () => PostsActions.fetchNextPage(ref),
      ),
    );
  }
}

class _PostsBody extends StatelessWidget {
  const _PostsBody({
    required this.state,
    required this.scrollController,
    required this.onRetryInitial,
    required this.onRetryPagination,
  });

  final PostsState state;
  final ScrollController scrollController;
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
      controller: scrollController,
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
