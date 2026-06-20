import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/create/create_post_actions.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/create/create_post_form.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_create_app_bar.dart';
import 'package:voinosis_jwt_board/features/posts/presentation/widgets/posts_form_page_layout.dart';
import 'package:voinosis_jwt_board/features/posts/provider/create_post_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CreatePostActions.reset(ref);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    await CreatePostActions.submit(
      ref: ref,
      title: _titleController.text,
      content: _contentController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostProvider);

    return PostsFormPageLayout(
      appBar: PostsCreateAppBar(
        onBackPressed: createPostState.isSubmitting
            ? null
            : () => CreatePostActions.goBack(
                  context: context,
                  isSubmitting: createPostState.isSubmitting,
                ),
      ),
      child: CreatePostForm(
        titleController: _titleController,
        contentController: _contentController,
        isSubmitting: createPostState.isSubmitting,
        errorMessage: createPostState.errorMessage,
        onSubmit: _handleSubmit,
      ),
    );
  }
}
