import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/features/auth/data/auth_exception.dart';
import 'package:voinosis_jwt_board/features/auth/data/auth_error_context.dart';
import 'package:voinosis_jwt_board/features/auth/data/auth_field_errors.dart';
import 'package:voinosis_jwt_board/features/auth/model/auth_response.dart';
import 'package:voinosis_jwt_board/features/auth/model/login_request.dart';
import 'package:voinosis_jwt_board/features/auth/model/signup_request.dart';
import 'package:voinosis_jwt_board/shared/constants/auth_api_constants.dart';
import 'package:voinosis_jwt_board/shared/constants/error_messages.dart';
import 'package:voinosis_jwt_board/shared/network/dio_exception_mapper.dart';

class AuthRepository {
  AuthRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        AuthApiPaths.login,
        data: request.toJson(),
      );

      return AuthResponse.fromJson(response.data!);
    } on DioException catch (error) {
      throw AuthException(
        DioExceptionMapper.toAuthFieldErrors(error, AuthErrorContext.login),
      );
    } catch (_) {
      throw const AuthException(
        AuthFieldErrors(fallbackMessage: ErrorMessages.unknown),
      );
    }
  }

  Future<void> signup(SignupRequest request) async {
    try {
      await _dio.post<void>(
        AuthApiPaths.signup,
        data: request.toJson(),
      );
    } on DioException catch (error) {
      throw AuthException(
        DioExceptionMapper.toAuthFieldErrors(error, AuthErrorContext.signup),
      );
    } catch (_) {
      throw const AuthException(
        AuthFieldErrors(fallbackMessage: ErrorMessages.unknown),
      );
    }
  }
}
