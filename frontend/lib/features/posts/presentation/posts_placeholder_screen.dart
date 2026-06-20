import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/auth/provider/auth_provider.dart';

class PostsPlaceholderScreen extends ConsumerWidget {
  const PostsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글'),
        actions: [
          TextButton(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            child: const Text('로그아웃 (임시)'),
          ),
        ],
      ),
      body: const Center(
        child: Text('게시글 목록 (임시 화면)'),
      ),
    );
  }
}
