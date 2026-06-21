import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/auth/data/auth_repository_provider.dart';
import 'package:voinosis_jwt_board/features/auth/model/login_request.dart';
import 'package:voinosis_jwt_board/features/auth/model/signup_request.dart';
import 'package:voinosis_jwt_board/features/auth/presentation/utils/auth_field_errors.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_state.dart';
import 'package:voinosis_jwt_board/shared/storage/secure_storage_service_provider.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(restoreSession);
    return const AuthState.initial();
  }

  Future<void> restoreSession() async {
    final secureStorage = ref.read(secureStorageServiceProvider);
    final token = await secureStorage.getToken();

    state = token != null && token.isNotEmpty
        ? const AuthState.authenticated()
        : const AuthState.unauthenticated();
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final secureStorage = ref.read(secureStorageServiceProvider);

      final response = await authRepository.login(
        LoginRequest(email: email, password: password),
      );

      await secureStorage.saveToken(response.accessToken);
      state = const AuthState.authenticated();
    } catch (e) {
      final errors = AuthFieldErrors.forLogin(e);
      state = AuthState.error(
        message: errors.fallbackMessage,
        emailError: errors.email,
        passwordError: errors.password,
      );
    }
  }

  Future<void> signup(String email, String password) async {
    state = const AuthState.loading();

    try {
      final authRepository = ref.read(authRepositoryProvider);

      await authRepository.signup(
        SignupRequest(email: email, password: password),
      );

      state = const AuthState.unauthenticated();
    } catch (e) {
      final errors = AuthFieldErrors.forSignup(e);
      state = AuthState.error(
        message: errors.fallbackMessage,
        emailError: errors.email,
        passwordError: errors.password,
      );
    }
  }

  Future<void> logout() async {
    final secureStorage = ref.read(secureStorageServiceProvider);
    await secureStorage.deleteToken();
    state = const AuthState.unauthenticated();
  }

  void clearEmailError() {
    if (state.emailError == null) {
      return;
    }

    state = state.copyWith(clearEmailError: true);
  }

  void clearPasswordError() {
    if (state.passwordError == null) {
      return;
    }

    state = state.copyWith(clearPasswordError: true);
  }
}
