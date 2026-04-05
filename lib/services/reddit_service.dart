import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chat_firebase/model/reddit_post.dart';
import 'package:chat_firebase/model/reddit_comment.dart';

class RedditService {
  static const String _baseUrl = 'https://www.reddit.com';
  static const Map<String, String> _headers = {
    'User-Agent': 'ChatForReddit/1.0',
  };

  /// Fetch hot posts from a subreddit
  Future<List<RedditPost>> fetchPosts(String subreddit, {int limit = 25}) async {
    final url = '$_baseUrl/r/$subreddit/hot.json?limit=$limit';
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final children = json['data']['children'] as List;
        return children
            .where((child) => child['kind'] == 't3')
            .map((child) => RedditPost.fromJson(child['data']))
            .toList();
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    return [];
  }

  /// Fetch popular/trending posts from r/popular
  Future<List<RedditPost>> fetchPopularPosts({int limit = 25}) async {
    return fetchPosts('popular', limit: limit);
  }

  /// Fetch comments for a post
  Future<List<RedditComment>> fetchComments(String permalink) async {
    final url = '$_baseUrl${permalink}.json?limit=50';
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        if (json.length >= 2) {
          final commentData = json[1]['data']['children'] as List;
          return _parseComments(commentData, 0);
        }
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
    return [];
  }

  /// Recursively parse comments and their replies
  List<RedditComment> _parseComments(List<dynamic> children, int depth) {
    final comments = <RedditComment>[];
    for (final child in children) {
      if (child['kind'] != 't1') continue;
      final data = child['data'];
      if (data == null) continue;

      comments.add(RedditComment.fromJson(data, depth: depth));

      // Parse nested replies
      if (data['replies'] is Map) {
        final replies = data['replies']['data']['children'] as List?;
        if (replies != null) {
          comments.addAll(_parseComments(replies, depth + 1));
        }
      }
    }
    return comments;
  }

  /// Search for subreddits
  Future<List<Map<String, String>>> searchSubreddits(String query) async {
    final url = '$_baseUrl/subreddits/search.json?q=$query&limit=10';
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final children = json['data']['children'] as List;
        return children.map((child) {
          final data = child['data'];
          return {
            'name': data['display_name'] as String? ?? '',
            'title': data['title'] as String? ?? '',
            'subscribers': (data['subscribers'] ?? 0).toString(),
            'icon': data['icon_img'] as String? ?? '',
          };
        }).toList();
      }
    } catch (e) {
      print('Error searching subreddits: $e');
    }
    return [];
  }
}
