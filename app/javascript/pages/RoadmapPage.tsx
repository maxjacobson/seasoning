import React, { FunctionComponent } from "react"
import { Markdown } from "../components/Markdown"

import { setHeadTitle } from "../hooks"

const roadmap = `
  Some things I'm planning to work on:

  1. Pagination on [the reviews page](/reviews)
  1. Pagination on a person's reviews page, for example [mine](/maxjacobson/reviews)
  1. Showing who someone follows on their page
  1. Showing who follows someone on their page
  1. Possible to remove a show from your shows
  1. Like button on reviews
  1. Comments on reviews
  1. Possible to edit reviews after publishing them -- body, star rating, visibility
`

export const RoadmapPage: FunctionComponent = () => {
  setHeadTitle("Roadmap")

  return (
    <div>
      <h1>Roadmap</h1>

      <Markdown markdown={roadmap} />
    </div>
  )
}
