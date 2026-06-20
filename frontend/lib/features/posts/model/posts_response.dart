import 'package:voinosis_jwt_board/features/posts/model/post_model.dart';
import 'package:voinosis_jwt_board/features/posts/model/posts_meta.dart';

class PostsResponse {
  const PostsResponse({
    required this.data,
    required this.meta,
  });

  final List<PostModel> data;
  final PostsMeta meta;

  factory PostsResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List<dynamic>;

    return PostsResponse(
      data: rawData
          .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      meta: PostsMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}
