import 'package:chat_firebase/model/reddit_comment.dart';
import 'package:chat_firebase/model/reddit_post.dart';
import 'package:chat_firebase/services/reddit_service.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/widgets/chat_room_box.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final RedditPost post;

  const ChatRoomPage({Key? key, required this.post}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final RedditService _redditService = RedditService();
  List<RedditComment> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    final comments = await _redditService.fetchComments(widget.post.permalink);
    setState(() {
      _comments = comments;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0.5,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: const [
              SizedBox(width: 8),
              Icon(Icons.arrow_back_ios, size: 20, color: primary),
            ],
          ),
        ),
        title: Column(
          children: [
            Text(
              'u/${widget.post.author}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'r/${widget.post.subreddit}',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildAvatar(widget.post.author, 32),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
              itemCount: _comments.length + 1, // +1 for the OP post
              itemBuilder: (context, index) {
                if (index == 0) {
                  // OP's post as the first blue bubble
                  return _buildOpBubble();
                }
                final comment = _comments[index - 1];
                return MessageBubble(
                  comment: comment,
                  isOp: comment.author == widget.post.author,
                );
              },
            ),
    );
  }

  Widget _buildOpBubble() {
    final text = widget.post.selftext.isNotEmpty
        ? '${widget.post.title}\n\n${widget.post.selftext}'
        : widget.post.title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 60),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: senderBubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: senderTextColor,
                      fontSize: 16,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.post.score} pts',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String username, double size) {
    final colorIndex = username.hashCode.abs() % subredditColors.length;
    final color = subredditColors[colorIndex];
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: color,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
