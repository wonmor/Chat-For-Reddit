import { NextRequest, NextResponse } from "next/server";
import { fetchPosts, fetchComments } from "@/lib/reddit";

export async function GET(req: NextRequest) {
  const { searchParams } = req.nextUrl;
  const type = searchParams.get("type");
  const subreddit = searchParams.get("subreddit");
  const permalink = searchParams.get("permalink");

  if (type === "posts" && subreddit) {
    const posts = await fetchPosts(subreddit);
    return NextResponse.json(posts);
  }

  if (type === "comments" && permalink) {
    const data = await fetchComments(permalink);
    return NextResponse.json(data);
  }

  return NextResponse.json({ error: "Invalid request" }, { status: 400 });
}
