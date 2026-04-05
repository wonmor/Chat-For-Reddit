class RedditPost {
  final String id;
  final String title;
  final String author;
  final String subreddit;
  final String selftext;
  final String permalink;
  final String? thumbnail;
  final int score;
  final int numComments;
  final DateTime createdAt;

  const RedditPost({
    required this.id,
    required this.title,
    required this.author,
    required this.subreddit,
    required this.selftext,
    required this.permalink,
    this.thumbnail,
    required this.score,
    required this.numComments,
    required this.createdAt,
  });

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    return RedditPost(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '[deleted]',
      subreddit: json['subreddit'] ?? '',
      selftext: json['selftext'] ?? '',
      permalink: json['permalink'] ?? '',
      thumbnail: json['thumbnail'],
      score: json['score'] ?? 0,
      numComments: json['num_comments'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        ((json['created_utc'] ?? 0) * 1000).toInt(),
      ),
    );
  }
}
