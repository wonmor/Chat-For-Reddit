export interface RedditPost {
  id: string;
  title: string;
  author: string;
  subreddit: string;
  selftext: string;
  permalink: string;
  thumbnail: string | null;
  score: number;
  numComments: number;
  createdAt: number;
}

export interface RedditComment {
  id: string;
  author: string;
  body: string;
  score: number;
  createdAt: number;
  depth: number;
}

const BASE_URL = "https://www.reddit.com";
const HEADERS = { "User-Agent": "ChatForReddit/1.0" };

export async function fetchPosts(
  subreddit: string,
  limit = 25
): Promise<RedditPost[]> {
  try {
    const res = await fetch(
      `${BASE_URL}/r/${subreddit}/hot.json?limit=${limit}`,
      { headers: HEADERS, next: { revalidate: 60 } }
    );
    if (!res.ok) return [];
    const json = await res.json();
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
  } catch {
    return [];
  }
}

export async function fetchComments(
  permalink: string
): Promise<{ post: RedditPost; comments: RedditComment[] }> {
  try {
    const res = await fetch(`${BASE_URL}${permalink}.json?limit=50`, {
      headers: HEADERS,
      next: { revalidate: 60 },
    });
    if (!res.ok) return { post: {} as RedditPost, comments: [] };
    const json = await res.json();

    const postData = json[0].data.children[0].data;
    const post: RedditPost = {
      id: postData.id,
      title: postData.title,
      author: postData.author,
      subreddit: postData.subreddit,
      selftext: postData.selftext || "",
      permalink: postData.permalink,
      thumbnail: postData.thumbnail,
      score: postData.score,
      numComments: postData.num_comments,
      createdAt: postData.created_utc,
    };

    const commentData = json[1].data.children;
    const comments = parseComments(commentData, 0);

    return { post, comments };
  } catch {
    return { post: {} as RedditPost, comments: [] };
  }
}

function parseComments(children: any[], depth: number): RedditComment[] {
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
      comments.push(...parseComments(d.replies.data.children, depth + 1));
    }
  }
  return comments;
}
