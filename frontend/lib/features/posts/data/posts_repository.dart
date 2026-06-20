import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/features/posts/data/posts_api_paths.dart';
import 'package:voinosis_jwt_board/features/posts/model/posts_response.dart';
import 'package:voinosis_jwt_board/shared/constants/error_messages.dart';

class PostsFetchException implements Exception {
  const PostsFetchException(this.message);

  final String message;

  @override
  String toString() => message;
}

class PostsRepository {
  PostsRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<PostsResponse> fetchPosts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        PostsApiPaths.posts,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return PostsResponse.fromJson(response.data!);
    } on DioException catch (error) {
      throw PostsFetchException(_messageFromDio(error));
    }
  }

  String _messageFromDio(DioException error) {
    if (_isNetworkError(error)) {
      return ErrorMessages.network;
    }

    final serverMessage = _extractServerMessage(error.response?.data);
    if (serverMessage != null) {
      return serverMessage;
    }

    return ErrorMessages.unknown;
  }

  bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }

  String? _extractServerMessage(dynamic data) {
    if (data is! Map) {
      return null;
    }

    final message = data['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }

    if (message is List) {
      return message.whereType<String>().join('\n');
    }

    return null;
  }
}
