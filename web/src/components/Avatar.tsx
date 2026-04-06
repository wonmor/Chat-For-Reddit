"use client";

import { avatarColor } from "@/lib/utils";

export default function Avatar({
  name,
  size = 48,
}: {
  name: string;
  size?: number;
}) {
  const color = avatarColor(name);
  const initial = name.charAt(0).toUpperCase();

  return (
    <div
      className="rounded-full flex items-center justify-center flex-shrink-0"
      style={{
        width: size,
        height: size,
        backgroundColor: color,
      }}
    >
      <span
        className="text-white font-semibold"
        style={{ fontSize: size * 0.4 }}
      >
        {initial}
      </span>
    </div>
  );
}
