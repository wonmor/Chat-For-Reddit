"use client";

import Avatar from "./Avatar";
import { RedditComment } from "@/lib/reddit";
import { timeAgo, formatScore } from "@/lib/utils";

export function OpBubble({
  title,
  selftext,
  score,
}: {
  title: string;
  selftext: string;
  score: number;
}) {
  const text = selftext ? `${title}\n\n${selftext}` : title;

  return (
    <div className="flex justify-end mb-1">
      <div className="ml-16" />
      <div className="bg-imessage-blue text-white px-4 py-2.5 rounded-[18px] rounded-br-[4px] max-w-[75%]">
        <p className="text-[16px] leading-relaxed whitespace-pre-wrap">{text}</p>
        <p className="text-[11px] text-white/70 text-right mt-1">
          {formatScore(score)} pts
        </p>
      </div>
    </div>
  );
}

export function CommentBubble({
  comment,
  isOp,
}: {
  comment: RedditComment;
  isOp: boolean;
}) {
  if (isOp) {
    return (
      <div className="flex justify-end mb-1">
        <div className="ml-16" />
        <div className="bg-imessage-blue text-white px-4 py-2.5 rounded-[18px] rounded-br-[4px] max-w-[75%]">
          <p className="text-[16px] leading-relaxed whitespace-pre-wrap">
            {comment.body}
          </p>
          <div className="flex items-center justify-end gap-2 mt-1">
            <span className="text-[11px] text-white/70">
              {formatScore(comment.score)} pts
            </span>
            <span className="text-[11px] text-white/70">
              {timeAgo(comment.createdAt)}
            </span>
          </div>
        </div>
      </div>
    );
  }

  const indent = Math.min(comment.depth * 12, 48);

  return (
    <div className="mb-1" style={{ paddingLeft: indent }}>
      {comment.depth === 0 && (
        <p className="text-[12px] text-gray-500 font-medium ml-11 mb-0.5 mt-2">
          u/{comment.author}
        </p>
      )}
      <div className="flex items-end gap-1.5">
        {comment.depth === 0 ? (
          <Avatar name={comment.author} size={32} />
        ) : (
          <div className="w-8" />
        )}
        <div className="bg-imessage-gray px-4 py-2.5 rounded-[18px] rounded-tl-[4px] max-w-[75%]">
          {comment.depth > 0 && (
            <p className="text-[12px] text-gray-500 font-semibold mb-0.5">
              u/{comment.author}
            </p>
          )}
          <p className="text-[16px] leading-relaxed text-black whitespace-pre-wrap">
            {comment.body}
          </p>
          <div className="flex items-center gap-2 mt-1">
            <span className="text-[11px] text-gray-500">
              {formatScore(comment.score)} pts
            </span>
            <span className="text-[11px] text-gray-500">
              {timeAgo(comment.createdAt)}
            </span>
          </div>
        </div>
        <div className="ml-16" />
      </div>
    </div>
  );
}
