import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_notifier.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_provider.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';
import 'package:voinosis_jwt_board/main.dart';

class _UnauthenticatedAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => const AuthState.unauthenticated();
}

void main() {
  testWidgets('JWT 없으면 로그인 화면을 표시한다', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(_UnauthenticatedAuthNotifier.new),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('JWT 익명 게시판'), findsOneWidget);
    expect(find.text('로그인'), findsWidgets);
  });
}
