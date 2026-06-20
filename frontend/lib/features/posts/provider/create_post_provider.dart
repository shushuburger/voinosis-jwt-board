import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/posts/provider/create_post_notifier.dart';
import 'package:voinosis_jwt_board/features/posts/provider/create_post_state.dart';

final createPostProvider =
    NotifierProvider<CreatePostNotifier, CreatePostState>(
  CreatePostNotifier.new,
);
