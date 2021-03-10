import React from "react"
import { render } from "react-dom"
import App from "./App"

render(
  React.createElement(App, {}, null),
  document.getElementById("app"),
)
