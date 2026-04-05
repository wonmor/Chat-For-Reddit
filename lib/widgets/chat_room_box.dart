import 'package:chat_firebase/model/reddit_comment.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/utils/global.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final RedditComment comment;
  final bool isOp;

  const MessageBubble({
    Key? key,
    required this.comment,
    this.isOp = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isOp) {
      return _buildSenderBubble();
    }
    return _buildReceiverBubble();
  }

  Widget _buildSenderBubble() {
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
                    comment.body,
                    style: const TextStyle(
                      color: senderTextColor,
                      fontSize: 16,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${comment.score} pts',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        getTimeAgo(comment.createdAt),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiverBubble() {
    final indent = (comment.depth * 12.0).clamp(0.0, 48.0);

    return Padding(
      padding: EdgeInsets.only(bottom: 4, left: indent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (comment.depth == 0)
            Padding(
              padding: const EdgeInsets.only(left: 44, bottom: 2, top: 6),
              child: Text(
                'u/${comment.author}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (comment.depth == 0) ...[
                _buildAvatar(comment.author),
                const SizedBox(width: 6),
              ] else
                const SizedBox(width: 40),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: comment.depth == 0
                        ? receiverBubbleColor
                        : receiverBubbleColor.withOpacity(0.7),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(4),
                      topRight: const Radius.circular(18),
                      bottomLeft: const Radius.circular(18),
                      bottomRight: const Radius.circular(18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (comment.depth > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            'u/${comment.author}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Text(
                        comment.body,
                        style: const TextStyle(
                          color: receiverTextColor,
                          fontSize: 16,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${comment.score} pts',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            getTimeAgo(comment.createdAt),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 60),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String username) {
    final colorIndex = username.hashCode.abs() % subredditColors.length;
    final color = subredditColors[colorIndex];
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: 16,
      backgroundColor: color,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
