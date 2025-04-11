class Feed {
  final int feedId;
  final String title;
  final String content;
  final String createdAt;
  final int likeCount;
  final bool liked;

  Feed({
    required this.feedId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.likeCount,
    required this.liked,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      feedId: json['feedId'],
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt'],
      likeCount: json['sumLike'] ?? 0,
      liked: (json['status'] ?? 0) == 1,
    );
  }
}


class FeedDetail {
  final String username;
  final String title;
  final String content;
  final int hits;
  final String createdAt;
  final int sumLike;
  final bool liked;

  FeedDetail({
    required this.username,
    required this.title,
    required this.content,
    required this.hits,
    required this.createdAt,
    required this.sumLike,
    required this.liked,
  });

  factory FeedDetail.fromJson(Map<String, dynamic> json) {
    return FeedDetail(
      username: json['username'],
      title: json['title'],
      content: json['content'],
      hits: json['hits'],
      createdAt: json['createdAt'],
      sumLike: json['sumLike'],
      liked: (json['status'] ?? 0) == 1,
    );
  }
}
