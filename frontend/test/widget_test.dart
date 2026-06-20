import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_notifier.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_provider.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/constants/posts_ui_text.dart';
import 'package:voinosis_jwt_board/features/posts/provider/posts_notifier.dart';
import 'package:voinosis_jwt_board/features/posts/provider/posts_provider.dart';
import 'package:voinosis_jwt_board/features/posts/provider/posts_state.dart';
import 'package:voinosis_jwt_board/main.dart';

class _UnauthenticatedAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => const AuthState.unauthenticated();
}

class _IdlePostsNotifier extends PostsNotifier {
  @override
  PostsState build() => const PostsState(currentPage: 1);

  @override
  Future<void> fetchInitialPosts() async {}
}

void main() {
  testWidgets('JWT 없어도 게시글 목록 화면을 표시한다', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(_UnauthenticatedAuthNotifier.new),
          postsProvider.overrideWith(_IdlePostsNotifier.new),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(PostsUiText.screenTitle), findsOneWidget);
    expect(find.text(PostsUiText.createButton), findsOneWidget);
  });
}
