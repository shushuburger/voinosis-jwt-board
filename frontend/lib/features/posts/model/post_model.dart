class PostModel {
  const PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String content;
  final int authorId;
  final DateTime createdAt;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
