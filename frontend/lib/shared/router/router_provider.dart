import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voinosis_jwt_board/shared/router/app_router.dart';
final routerProvider = Provider<GoRouter>((ref) {
  return createAppRouter(ref);
});
