import 'package:dio/dio.dart';
import 'package:voinosis_jwt_board/shared/constants/pagination_constants.dart';
import 'package:voinosis_jwt_board/features/posts/data/posts_api_paths.dart';
import 'package:voinosis_jwt_board/features/posts/model/create_post_request.dart';
import 'package:voinosis_jwt_board/features/posts/model/post_model.dart';
import 'package:voinosis_jwt_board/features/posts/model/posts_response.dart';
import 'package:voinosis_jwt_board/shared/network/dio_exception_mapper.dart';

class PostsRepository {
  PostsRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<PostsResponse> fetchPosts({
    int page = PaginationConstants.defaultPage,
    int limit = PaginationConstants.defaultLimit,
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
      throw DioExceptionMapper.toApiRequestException(error);
    }
  }

  Future<PostModel> createPost(CreatePostRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        PostsApiPaths.posts,
        data: request.toJson(),
      );

      return PostModel.fromJson(response.data!);
    } on DioException catch (error) {
      throw DioExceptionMapper.toApiRequestException(error);
    }
  }
}
