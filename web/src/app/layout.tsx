import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "SubChat",
  description: "iMessage-style Reddit browser",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-white min-h-screen">
        <div className="max-w-lg mx-auto min-h-screen bg-white shadow-xl">
          {children}
        </div>
      </body>
    </html>
  );
}
