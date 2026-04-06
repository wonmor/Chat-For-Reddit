"use client";

import Link from "next/link";
import Avatar from "./Avatar";
import { RedditPost } from "@/lib/reddit";
import { timeAgo, formatScore } from "@/lib/utils";

export default function PostRow({ post }: { post: RedditPost }) {
  return (
    <Link
      href={`/thread/${post.id}?permalink=${encodeURIComponent(post.permalink)}`}
      className="flex items-start gap-3 px-4 py-3 hover:bg-gray-50 active:bg-gray-100 transition-colors cursor-pointer"
    >
      <Avatar name={post.subreddit} />
      <div className="flex-1 min-w-0">
        <div className="flex items-center justify-between">
          <span className="font-semibold text-[15px] text-black truncate">
            r/{post.subreddit}
          </span>
          <div className="flex items-center gap-1 flex-shrink-0 ml-2">
            <span className="text-[13px] text-gray-400">
              {timeAgo(post.createdAt)}
            </span>
            <svg
              className="w-4 h-4 text-gray-300"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M9 5l7 7-7 7"
              />
            </svg>
          </div>
        </div>
        <p className="text-[14px] text-gray-500 line-clamp-2 leading-snug mt-0.5">
          {post.title}
        </p>
        <div className="flex items-center gap-3 mt-1 text-[12px] text-gray-400">
          <span className="flex items-center gap-0.5">
            ▲ {formatScore(post.score)}
          </span>
          <span className="flex items-center gap-0.5">
            💬 {post.numComments}
          </span>
        </div>
      </div>
    </Link>
  );
}
