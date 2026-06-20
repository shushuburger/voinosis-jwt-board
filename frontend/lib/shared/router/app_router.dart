import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/login/login_screen.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/signup/signup_screen.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/posts_placeholder_screen.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';

GoRouter createAppRouter(AuthState authState) {
  return GoRouter(
    initialLocation: RoutePaths.home,
    redirect: (context, state) => _redirect(authState, state.matchedLocation),
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

String? _redirect(AuthState authState, String location) {
  final isAuthRoute =
      location == RoutePaths.login || location == RoutePaths.signup;

  switch (authState.status) {
    case AuthStatus.initial:
    case AuthStatus.loading:
      return null;
    case AuthStatus.authenticated:
      return isAuthRoute ? RoutePaths.home : null;
    case AuthStatus.unauthenticated:
    case AuthStatus.error:
      return isAuthRoute ? null : RoutePaths.login;
  }
}
