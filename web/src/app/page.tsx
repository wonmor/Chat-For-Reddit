"use client";

import { useEffect, useState } from "react";
import { RedditPost } from "@/lib/reddit";
import PostRow from "@/components/PostRow";
import Link from "next/link";

const DEFAULT_SUBREDDITS = [
  "popular", "AskReddit", "worldnews", "funny", "todayilearned",
  "science", "gaming", "movies", "technology", "pics",
];

const CORS_PROXY = "https://corsproxy.io/?";

export default function HomePage() {
  const [posts, setPosts] = useState<RedditPost[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    loadPosts();
  }, []);

  async function loadPosts() {
    setLoading(true);
    setError("");
    try {
      const url = `${CORS_PROXY}${encodeURIComponent("https://www.reddit.com/r/popular/hot.json?limit=30")}`;
      const res = await fetch(url);
      const json = await res.json();
      const items: RedditPost[] = json.data.children
        .filter((c: any) => c.kind === "t3")
        .map((c: any) => ({
          id: c.data.id,
          title: c.data.title,
          author: c.data.author,
          subreddit: c.data.subreddit,
          selftext: c.data.selftext || "",
          permalink: c.data.permalink,
          thumbnail: c.data.thumbnail,
          score: c.data.score,
          numComments: c.data.num_comments,
          createdAt: c.data.created_utc,
        }));
      setPosts(items);
    } catch (e) {
      setError("Failed to load posts. Pull to refresh.");
    }
    setLoading(false);
  }

  return (
    <div className="flex flex-col h-screen">
      <div className="px-5 pt-14 pb-2 flex items-center justify-between">
        <h1 className="text-[32px] font-bold text-black">Messages</h1>
        <button onClick={loadPosts} className="text-imessage-blue p-2">
          <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
          </svg>
        </button>
      </div>

      <div className="px-4 pb-2">
        <div className="bg-imessage-lightgray rounded-xl px-4 py-2.5 flex items-center gap-2">
          <svg className="w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
          <span className="text-[16px] text-gray-400">Search</span>
        </div>
      </div>

      <div className="px-4 pb-2 flex gap-2 overflow-x-auto hide-scrollbar">
        {DEFAULT_SUBREDDITS.map((sub) => (
          <Link
            key={sub}
            href={`/r/${sub}`}
            className="flex-shrink-0 bg-imessage-blue/10 text-imessage-blue text-[13px] font-medium px-3 py-1.5 rounded-full hover:bg-imessage-blue/20 transition-colors"
          >
            r/{sub}
          </Link>
        ))}
      </div>

      <div className="flex-1 overflow-y-auto">
        {loading ? (
          <div className="flex items-center justify-center h-64">
            <div className="w-6 h-6 border-2 border-imessage-blue border-t-transparent rounded-full animate-spin" />
          </div>
        ) : error ? (
          <div className="flex flex-col items-center justify-center h-64 text-gray-400">
            <p className="text-lg">{error}</p>
            <button onClick={loadPosts} className="text-imessage-blue mt-3 text-sm">Retry</button>
          </div>
        ) : (
          <div className="divide-y divide-gray-100">
            {posts.map((post) => (
              <PostRow key={post.id} post={post} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
