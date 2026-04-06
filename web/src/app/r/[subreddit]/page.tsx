"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { RedditPost } from "@/lib/reddit";
import { clientFetchPosts } from "@/lib/client-reddit";
import PostRow from "@/components/PostRow";
import Link from "next/link";

export default function SubredditPage() {
  const params = useParams();
  const subreddit = params.subreddit as string;
  const [posts, setPosts] = useState<RedditPost[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadPosts();
  }, [subreddit]);

  async function loadPosts() {
    setLoading(true);
    try {
      setPosts(await clientFetchPosts(subreddit));
    } catch {
      setPosts([]);
    }
    setLoading(false);
  }

  return (
    <div className="flex flex-col h-screen">
      <div className="bg-white/95 backdrop-blur-md border-b border-gray-200 px-4 pt-12 pb-3 sticky top-0 z-10">
        <div className="flex items-center">
          <Link href="/" className="text-imessage-blue text-[17px] flex items-center gap-0.5 mr-4">
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
            Back
          </Link>
          <div className="flex-1 text-center">
            <h1 className="text-[17px] font-semibold text-black">r/{subreddit}</h1>
            <p className="text-[12px] text-gray-400">{posts.length} posts</p>
          </div>
          <div className="w-16" />
        </div>
      </div>

      <div className="flex-1 overflow-y-auto">
        {loading ? (
          <div className="flex items-center justify-center h-64">
            <div className="w-6 h-6 border-2 border-imessage-blue border-t-transparent rounded-full animate-spin" />
          </div>
        ) : posts.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-64 text-gray-400">
            <p>No posts found</p>
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
