import { NextRequest, NextResponse } from "next/server";

export const runtime = "edge";

let cachedToken: string | null = null;
let tokenExpiry = 0;

async function getAccessToken(): Promise<string> {
  const now = Date.now();
  if (cachedToken && now < tokenExpiry) return cachedToken;

  const clientId = process.env.REDDIT_CLIENT_ID;
  const clientSecret = process.env.REDDIT_CLIENT_SECRET;

  if (!clientId || !clientSecret) {
    throw new Error("Reddit API credentials not configured");
  }

  const auth = btoa(`${clientId}:${clientSecret}`);
  const res = await fetch("https://www.reddit.com/api/v1/access_token", {
    method: "POST",
    headers: {
      Authorization: `Basic ${auth}`,
      "Content-Type": "application/x-www-form-urlencoded",
      "User-Agent": "SubChat/1.0",
    },
    body: "grant_type=client_credentials",
  });

  if (!res.ok) {
    throw new Error(`Token request failed: ${res.status}`);
  }

  const data = await res.json();
  cachedToken = data.access_token;
  // Expire 5 min early to be safe
  tokenExpiry = now + (data.expires_in - 300) * 1000;
  return cachedToken!;
}

async function redditApiFetch(path: string): Promise<any> {
  const token = await getAccessToken();
  const res = await fetch(`https://oauth.reddit.com${path}`, {
    headers: {
      Authorization: `Bearer ${token}`,
      "User-Agent": "SubChat/1.0",
    },
  });

  if (!res.ok) {
    throw new Error(`Reddit API returned ${res.status}`);
  }

  return res.json();
}

function parsePosts(json: any) {
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

function parseComments(children: any[], depth: number): any[] {
  const comments: any[] = [];
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

export async function GET(req: NextRequest) {
  const url = req.nextUrl.searchParams.get("url");
  const type = req.nextUrl.searchParams.get("type");
  const subreddit = req.nextUrl.searchParams.get("subreddit");
  const permalink = req.nextUrl.searchParams.get("permalink");

  try {
    // Structured API calls
    if (type === "posts" && subreddit) {
      const json = await redditApiFetch(`/r/${subreddit}/hot?limit=30&raw_json=1`);
      return NextResponse.json(parsePosts(json));
    }

    if (type === "comments" && permalink) {
      const json = await redditApiFetch(`${permalink}?limit=50&raw_json=1`);
      const postData = json[0].data.children[0].data;
      const post = {
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
      const comments = parseComments(json[1].data.children, 0);
      return NextResponse.json({ post, comments });
    }

    // Raw URL proxy (fallback)
    if (url && url.includes("reddit.com")) {
      const path = new URL(url).pathname + new URL(url).search;
      const json = await redditApiFetch(path.replace(".json", ""));
      return NextResponse.json(json);
    }
  } catch (e: any) {
    return NextResponse.json(
      { error: e.message || "Failed to fetch" },
      { status: 502 }
    );
  }

  return NextResponse.json({ error: "Invalid request" }, { status: 400 });
}
