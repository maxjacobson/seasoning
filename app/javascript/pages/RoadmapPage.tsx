import React, { FunctionComponent } from "react"
import { Markdown } from "../components/Markdown"

import { setHeadTitle } from "../hooks"

const roadmap = `
  Some things I'm planning to work on:

  1. Pagination on [the reviews page](/reviews)
  1. Pagination on a person's reviews page, for example [mine](/maxjacobson/reviews)
  1. Possible to remove a show from your shows
  1. Like button on reviews
  1. Comments on reviews
  1. Possible to edit reviews after publishing them -- body, star rating, visibility
  1. Option to unfollow someone after following them
  1. Sort following and followers pages by when it happened
  1. Ability to mark individual episodes as seen
  1. Display air dates for shows and seasons
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
