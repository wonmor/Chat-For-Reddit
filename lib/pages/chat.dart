import 'package:chat_firebase/model/reddit_post.dart';
import 'package:chat_firebase/services/reddit_service.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/widgets/chat_item.dart';
import 'package:flutter/material.dart';

import 'chat_room.dart';

class ChatPage extends StatefulWidget {
  final String subreddit;
  final RedditPost? initialPost;

  const ChatPage({Key? key, required this.subreddit, this.initialPost}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final RedditService _redditService = RedditService();
  List<RedditPost> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();

    // If we have an initial post, navigate to it after build
    if (widget.initialPost != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(post: widget.initialPost!),
          ),
        );
      });
    }
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    final posts = await _redditService.fetchPosts(widget.subreddit, limit: 30);
    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        elevation: 0,
        leading: IconButton(
          icon: Row(
            children: const [
              Icon(Icons.arrow_back_ios, size: 20, color: primary),
            ],
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(
              'r/${widget.subreddit}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_posts.length} posts',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : RefreshIndicator(
              onRefresh: _loadPosts,
              color: primary,
              child: ListView.separated(
                itemCount: _posts.length,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 76),
                  child: Divider(height: 1, color: Colors.grey.shade200),
                ),
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return PostItem(
                    post: post,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatRoomPage(post: post),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
