import 'package:chat_firebase/model/reddit_post.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/utils/global.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final RedditPost post;
  final GestureTapCallback? onTap;

  const PostItem({Key? key, required this.post, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'r/${post.subreddit}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        getTimeAgo(post.createdAt),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    post.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.arrow_upward_rounded, size: 13, color: Colors.grey.shade400),
                      const SizedBox(width: 2),
                      Text(
                        formatScore(post.score),
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.chat_bubble_outline, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 2),
                      Text(
                        '${post.numComments}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final colorIndex = post.subreddit.hashCode.abs() % subredditColors.length;
    final color = subredditColors[colorIndex];
    final initial = post.subreddit.isNotEmpty ? post.subreddit[0].toUpperCase() : 'R';

    return CircleAvatar(
      radius: 24,
      backgroundColor: color,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
