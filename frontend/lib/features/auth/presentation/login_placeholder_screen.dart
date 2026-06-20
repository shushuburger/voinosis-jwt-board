import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';

class LoginPlaceholderScreen extends StatelessWidget {
  const LoginPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('로그인 (임시 화면)'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(RoutePaths.signup),
              child: const Text('회원가입으로 이동'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(RoutePaths.home),
              child: const Text('게시글 목록으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
