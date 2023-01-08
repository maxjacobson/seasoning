import React, { FunctionComponent } from "react"
import { Markdown } from "../components/Markdown"

import { setHeadTitle } from "../hooks"

const changelog = `
  As mentioned on [the credits page](/credits), this whole thing is open source, so feel free to check out [the repo](https://github.com/maxjacobson/seasoning) on GitHub.

  But here's some highlights of when things happened.

  1. **January 7, 2023** -- New page for individual episodes
  1. **January 7, 2023** -- People can mark individual episodes as seen
  1. **January 7, 2023** -- start recording episode details in database
  1. **December 24, 2022** -- add following and followers page to profiles
  1. **December 24, 2022** -- add simple admin page with some basic stats
  1. **December 24, 2022** -- add [changelog page](/changelog) and [roadmap page](/roadmap)
  1. **December 24, 2022** -- limit [the reviews page](/reviews) to your own reviews, and reviews from people you follow
  1. **December 24, 2022** -- limit [an individual's reviews page](/maxjacobson/reviews) to 10 recent reviews
  1. **December 24, 2022** -- limit [the reviews page](/reviews) to 10 recent reviews
  1. **December 24, 2022** -- limit [the reviews page](/reviews) to authenticated guests
  1. **December 19, 2022** -- Order shows on homepage by title and status, not just status
  1. **June 18, 2022** -- Magic links are now more flexibile, and will work even if you type your email with mixed case or trailing spaces
  1. **June 18, 2022** -- People can delete their reviews
  1. **June 18, 2022** -- When filtering homepage, save the filters in the URL so they can be sticky
  1. **June 18, 2022** -- Show the note to self on the homepage
  1. **May 22, 2022** -- Make it possible to import two shows with the same name, for remakes etc
  1. **April 4, 2022** -- Improve experience when importing shows
  1. **November 5, 2021** -- Improve show import flow by doing a search and letting you pick the one you actually definitely want
  1. **October 24, 2021** -- Add new "next up" show status, and automatically move shows into that status when a new season is available
  1. **October 10, 2021** -- Redesign to stop using [Shopify's Polaris design system](https://polaris.shopify.com/) but, rather, just use a really small handful of lines of CSS
  1. **May 1, 2021** -- Display season-specific posters
  1. **April 26, 2021** -- People can set their default review visibility for new reviews
  1. **April 25, 2021** -- People can tick off which seasons of shows that they've seen from the show page
  1. **April 25, 2021** -- Link to profile page from review page
  1. **April 11, 2021** -- [first review](/maxjacobson/shows/the-man-in-the-high-castle/season-1) is posted
  1. **April 11, 2021** -- Show global feed of reviews on [reviews page](/reviews)
  1. **April 10, 2021** -- People can write reviews of seasons of shows, with star ratings, text, and visibility
  1. **April 10, 2021** -- People can follow each other
  1. **April 10, 2021** -- People can choose whether or not to show their currently watching shows on their profile page
  1. **April 10, 2021** -- People can filter the homepage by show status
  1. **April 5, 2021** -- People can tick off which seasons of shows that they've seen
  1. **April 4, 2021** -- People can indicate the status of their relationship to a show (currently watching, waiting for more, etc)
  1. **April 4, 2021** -- Display show posters
  1. **March 28, 2021** -- Added a navbar
  1. **March 27, 2021** -- Switch from Wikipedia to TMDB as the source of data
  1. **March 21, 2021** -- People can search for shows
  1. **March 14, 2021** -- People can add "note to self" about a show
  1. **March 13, 2021** -- People can add shows they're interested in
  1. **March 9, 2021** -- Development starts
`

export const ChangelogPage: FunctionComponent = () => {
  setHeadTitle("Changelog")

  return (
    <div>
      <h1>Changelog</h1>

      <Markdown markdown={changelog} />
    </div>
  )
}
