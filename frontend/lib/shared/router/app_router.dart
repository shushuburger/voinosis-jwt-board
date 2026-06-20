import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/login/login_screen.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/signup/signup_screen.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/posts_placeholder_screen.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const PostsPlaceholderScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        builder: (context, state) => const SignupScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('오류')),
      body: Center(
        child: Text('페이지를 찾을 수 없습니다: ${state.uri}'),
      ),
    ),
  );
}
