import { fetchPosts } from "@/lib/reddit";
import PostRow from "@/components/PostRow";
import Link from "next/link";

export const dynamic = "force-dynamic";

const DEFAULT_SUBREDDITS = [
  "popular", "AskReddit", "worldnews", "funny", "todayilearned",
  "science", "gaming", "movies", "technology", "pics",
];

export default async function HomePage() {
  const posts = await fetchPosts("popular", 30);

  return (
    <div className="flex flex-col h-screen">
      {/* Header */}
      <div className="px-5 pt-14 pb-2">
        <h1 className="text-[32px] font-bold text-black">Messages</h1>
      </div>

      {/* Search bar */}
      <div className="px-4 pb-2">
        <div className="bg-imessage-lightgray rounded-xl px-4 py-2.5 flex items-center gap-2">
          <svg
            className="w-4 h-4 text-gray-400"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
            />
          </svg>
          <span className="text-[16px] text-gray-400">Search</span>
        </div>
      </div>

      {/* Subreddit chips */}
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

      {/* Posts */}
      <div className="flex-1 overflow-y-auto">
        {posts.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-64 text-gray-400">
            <p className="text-lg">No posts found</p>
            <p className="text-sm mt-1">Check your connection</p>
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
