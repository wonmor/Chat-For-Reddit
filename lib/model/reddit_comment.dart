class RedditComment {
  final String id;
  final String author;
  final String body;
  final int score;
  final DateTime createdAt;
  final int depth;

  const RedditComment({
    required this.id,
    required this.author,
    required this.body,
    required this.score,
    required this.createdAt,
    this.depth = 0,
  });

  factory RedditComment.fromJson(Map<String, dynamic> json, {int depth = 0}) {
    return RedditComment(
      id: json['id'] ?? '',
      author: json['author'] ?? '[deleted]',
      body: json['body'] ?? '',
      score: json['score'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        ((json['created_utc'] ?? 0) * 1000).toInt(),
      ),
      depth: depth,
    );
  }
}
