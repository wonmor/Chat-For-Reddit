import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        imessage: {
          blue: "#007AFF",
          gray: "#E5E5EA",
          bg: "#EFEFF4",
          lightgray: "#F2F2F7",
        },
      },
    },
  },
  plugins: [],
};
export default config;
