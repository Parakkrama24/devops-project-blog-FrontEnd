import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from '@tailwindcss/vite'


// https://vite.dev/config/
export default defineConfig({
  server: {
    host: "127.0.0.1",
    port: 3000, // or any other unused port
  },
  plugins: [react(),  tailwindcss(),],
});
