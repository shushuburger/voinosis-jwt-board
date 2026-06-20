import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voinosis_jwt_board/main.dart';

void main() {
  testWidgets('앱이 게시글 임시 화면을 표시한다', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: App()),
    );
    await tester.pumpAndSettle();

    expect(find.text('게시글 목록 (임시 화면)'), findsOneWidget);
  });
}
