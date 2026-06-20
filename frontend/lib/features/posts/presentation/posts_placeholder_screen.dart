import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';

class PostsPlaceholderScreen extends StatelessWidget {
  const PostsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게시글')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('게시글 목록 (임시 화면)'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(RoutePaths.login),
              child: const Text('로그인으로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
