import { defineConfig } from "vite"
import RubyPlugin from "vite-plugin-ruby"
import ReactRefresh from "@vitejs/plugin-react-refresh"

export default defineConfig({
  plugins: [ReactRefresh(), RubyPlugin()],
})
