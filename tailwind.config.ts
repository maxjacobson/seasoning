/* eslint-disable import/no-default-export */
import { Config } from "tailwindcss"
import forms from "@tailwindcss/forms"

const config: Config = {
  content: ["./app/**/*.{ts,tsx}"],

  theme: {
    extend: {},
  },
  plugins: [forms],
}

export default config
