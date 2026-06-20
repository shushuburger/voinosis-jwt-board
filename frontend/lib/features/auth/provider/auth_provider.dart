import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_notifier.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
