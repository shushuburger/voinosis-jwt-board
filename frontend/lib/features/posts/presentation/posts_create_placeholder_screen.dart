import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_constants.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_text.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_create_app_bar.dart';

/// Issue #9에서 실제 게시글 작성 화면으로 교체 예정.
class PostsCreatePlaceholderScreen extends StatelessWidget {
  const PostsCreatePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PostsUiConstants.backgroundColor,
      appBar: PostsCreateAppBar(
        onBackPressed: () => context.pop(),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: PostsUiConstants.stateViewHorizontalPadding,
          ),
          child: Text(
            PostsUiText.createPlaceholderMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: PostsUiConstants.subtitleColor,
            ),
          ),
        ),
      ),
    );
  }
}
