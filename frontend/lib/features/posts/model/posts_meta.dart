class PostsMeta {
  const PostsMeta({
    required this.total,
    required this.page,
    required this.lastPage,
  });

  final int total;
  final int page;
  final int lastPage;

  factory PostsMeta.fromJson(Map<String, dynamic> json) {
    return PostsMeta(
      total: json['total'] as int,
      page: json['page'] as int,
      lastPage: json['lastPage'] as int,
    );
  }
}
