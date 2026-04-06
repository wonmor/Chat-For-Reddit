import { RedditPost, RedditComment } from "./reddit";

function parsePostsFromJson(json: any): RedditPost[] {
  return json.data.children
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
}

function parseCommentsFromJson(children: any[], depth: number): RedditComment[] {
  const comments: RedditComment[] = [];
  for (const child of children) {
    if (child.kind !== "t1") continue;
    const d = child.data;
    if (!d) continue;
    comments.push({
      id: d.id,
      author: d.author,
      body: d.body,
      score: d.score,
      createdAt: d.created_utc,
      depth,
    });
    if (d.replies?.data?.children) {
      comments.push(...parseCommentsFromJson(d.replies.data.children, depth + 1));
    }
  }
  return comments;
}

export async function clientFetchPosts(subreddit: string): Promise<RedditPost[]> {
  // Use our OAuth API route
  const res = await fetch(`/api/reddit-proxy?type=posts&subreddit=${encodeURIComponent(subreddit)}`);
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.error || `API returned ${res.status}`);
  }
  const data = await res.json();
  if (data.error) throw new Error(data.error);
  return data;
}

export async function clientFetchThread(
  permalink: string
): Promise<{ post: RedditPost; comments: RedditComment[] }> {
  const res = await fetch(`/api/reddit-proxy?type=comments&permalink=${encodeURIComponent(permalink)}`);
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.error || `API returned ${res.status}`);
  }
  const data = await res.json();
  if (data.error) throw new Error(data.error);
  return data;
}
