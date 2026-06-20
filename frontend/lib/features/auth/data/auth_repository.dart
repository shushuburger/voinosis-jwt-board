import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/features/auth/model/auth_response.dart';
import 'package:voinosis_jwt_board/features/auth/model/login_request.dart';
import 'package:voinosis_jwt_board/features/auth/model/signup_request.dart';

class AuthRepository {
  AuthRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  static const _loginPath = '/auth/login';
  static const _signupPath = '/auth/signup';

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _loginPath,
      data: request.toJson(),
    );

    return AuthResponse.fromJson(response.data!);
  }

  Future<void> signup(SignupRequest request) async {
    await _dio.post<void>(
      _signupPath,
      data: request.toJson(),
    );
  }
}
