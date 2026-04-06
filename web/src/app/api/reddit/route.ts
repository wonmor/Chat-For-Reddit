import { NextRequest, NextResponse } from "next/server";

// Run on Vercel Edge (Cloudflare network) — different IPs than serverless
export const runtime = "edge";

const HEADERS: Record<string, string> = {
  "User-Agent":
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
  Accept: "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
  "Accept-Language": "en-US,en;q=0.9",
};

const ENDPOINTS = [
  "https://www.reddit.com",
  "https://old.reddit.com",
];

async function redditFetch(path: string): Promise<any> {
  let lastError = "";

  for (const base of ENDPOINTS) {
    try {
      const res = await fetch(`${base}${path}`, { headers: HEADERS });
      if (res.ok) {
        return await res.json();
      }
      lastError = `${base} returned ${res.status}`;
    } catch (e: any) {
      lastError = `${base}: ${e.message}`;
    }
  }

  throw new Error(lastError);
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
  const { searchParams } = req.nextUrl;
  const type = searchParams.get("type");
  const subreddit = searchParams.get("subreddit");
  const permalink = searchParams.get("permalink");

  try {
    if (type === "posts" && subreddit) {
      const json = await redditFetch(
        `/r/${subreddit}/hot.json?limit=30&raw_json=1`
      );
      return NextResponse.json(parsePosts(json));
    }

    if (type === "comments" && permalink) {
      const json = await redditFetch(
        `${permalink}.json?limit=50&raw_json=1`
      );
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
  } catch (e: any) {
    return NextResponse.json(
      { error: e.message || "Failed to fetch from Reddit" },
      { status: 502 }
    );
  }

  return NextResponse.json({ error: "Invalid request" }, { status: 400 });
}
