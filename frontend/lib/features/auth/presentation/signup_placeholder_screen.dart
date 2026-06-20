import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';

class SignupPlaceholderScreen extends StatelessWidget {
  const SignupPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('회원가입 (임시 화면)'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go(RoutePaths.login),
              child: const Text('로그인으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
