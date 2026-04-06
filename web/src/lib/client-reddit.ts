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

// Try fetching a Reddit JSON URL through multiple methods
async function fetchRedditJson(redditPath: string): Promise<any> {
  const redditUrl = `https://www.reddit.com${redditPath}`;

  // Method 1: Our own API route (Edge Runtime)
  try {
    const res = await fetch(`/api/reddit-proxy?url=${encodeURIComponent(redditUrl)}`);
    if (res.ok) {
      const data = await res.json();
      if (data && !data.error) return data;
    }
  } catch {}

  // Method 2: allorigins.win proxy
  try {
    const res = await fetch(
      `https://api.allorigins.win/raw?url=${encodeURIComponent(redditUrl)}`
    );
    if (res.ok) return await res.json();
  } catch {}

  // Method 3: corsproxy.io
  try {
    const res = await fetch(
      `https://corsproxy.io/?${encodeURIComponent(redditUrl)}`
    );
    if (res.ok) return await res.json();
  } catch {}

  // Method 4: jsonp-style via cors-anywhere alternatives
  try {
    const res = await fetch(
      `https://api.codetabs.com/v1/proxy?quest=${encodeURIComponent(redditUrl)}`
    );
    if (res.ok) return await res.json();
  } catch {}

  throw new Error("All fetch methods failed");
}

export async function clientFetchPosts(subreddit: string): Promise<RedditPost[]> {
  const json = await fetchRedditJson(`/r/${subreddit}/hot.json?limit=30&raw_json=1`);
  return parsePostsFromJson(json);
}

export async function clientFetchThread(
  permalink: string
): Promise<{ post: RedditPost; comments: RedditComment[] }> {
  const json = await fetchRedditJson(`${permalink}.json?limit=50&raw_json=1`);

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

  const comments = parseCommentsFromJson(json[1].data.children, 0);
  return { post, comments };
}
