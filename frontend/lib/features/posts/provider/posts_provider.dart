import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/posts/provider/posts_notifier.dart';
import 'package:voinosis_jwt_board/features/posts/provider/posts_state.dart';

final postsProvider =
    NotifierProvider<PostsNotifier, PostsState>(PostsNotifier.new);
