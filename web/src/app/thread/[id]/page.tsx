import { fetchComments } from "@/lib/reddit";
import { OpBubble, CommentBubble } from "@/components/MessageBubble";
import Avatar from "@/components/Avatar";
import Link from "next/link";

export const dynamic = "force-dynamic";

export default async function ThreadPage({
  params,
  searchParams,
}: {
  params: { id: string };
  searchParams: { permalink?: string };
}) {
  const permalink = searchParams.permalink || "";
  const { post, comments } = await fetchComments(permalink);

  return (
    <div className="flex flex-col h-screen">
      {/* Header */}
      <div className="bg-[#F9F9F9]/95 backdrop-blur-md border-b border-gray-200 px-4 pt-12 pb-3 sticky top-0 z-10">
        <div className="flex items-center">
          <Link
            href="/"
            className="text-imessage-blue text-[17px] flex items-center gap-0.5 mr-3"
          >
            <svg
              className="w-5 h-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M15 19l-7-7 7-7"
              />
            </svg>
          </Link>
          <div className="flex-1 text-center">
            <p className="text-[16px] font-semibold text-black">
              u/{post.author}
            </p>
            <p className="text-[12px] text-gray-400">r/{post.subreddit}</p>
          </div>
          <Avatar name={post.author || "?"} size={32} />
        </div>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto bg-imessage-bg px-2 py-3">
        {/* OP Post */}
        <OpBubble
          title={post.title}
          selftext={post.selftext}
          score={post.score}
        />

        {/* Comments as messages */}
        {comments.map((comment) => (
          <CommentBubble
            key={comment.id}
            comment={comment}
            isOp={comment.author === post.author}
          />
        ))}

        {comments.length === 0 && (
          <div className="text-center text-gray-400 text-sm mt-8">
            No comments yet
          </div>
        )}
      </div>
    </div>
  );
}
