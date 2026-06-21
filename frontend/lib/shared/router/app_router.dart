import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/login/login_screen.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/signup/signup_screen.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_provider.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/create/create_post_screen.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/posts_list_screen.dart';
import 'package:voinosis_jwt_board/shared/constants/route_constants.dart';
import 'package:voinosis_jwt_board/shared/constants/router_ui_text.dart';

GoRouter createAppRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: RoutePaths.home,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      return _redirect(authState, state.matchedLocation);
    },
    routes: [
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const PostsListScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RoutePaths.postsCreate,
        builder: (context, state) => const CreatePostScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text(RouterUiText.errorTitle)),
      body: Center(
        child: Text('${RouterUiText.pageNotFoundPrefix}${state.uri}'),
      ),
    ),
  );

  ref.listen(authProvider, (_, __) {
    router.refresh();
  });

  ref.onDispose(router.dispose);

  return router;
}

String? _redirect(AuthState authState, String location) {
  final isAuthRoute =
      location == RoutePaths.login || location == RoutePaths.signup;
  final isPublicRoute = location == RoutePaths.home || isAuthRoute;

  switch (authState.status) {
    case AuthStatus.initial:
    case AuthStatus.loading:
      return null;
    case AuthStatus.authenticated:
      return isAuthRoute ? RoutePaths.home : null;
    case AuthStatus.unauthenticated:
    case AuthStatus.error:
      return isPublicRoute ? null : RoutePaths.login;
  }
}
