class CreatePostRequest {
  const CreatePostRequest({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };
}
