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
  1. Display air dates for shows and seasons
  1. Can display your favorite shows on your page (like Letterboxd)
  1. Lists of shows
  1. Lists of seasons
  1. Show the "note to self" on the homepage
  1. Page that shows you what episodes are available from your currently watching shows
  1. RSS feed for public reviews
  1. An activity feed for the people you follow
  1. A way to indicate that you're rewatching a show/season, not watching it for the first time
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
