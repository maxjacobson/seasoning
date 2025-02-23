# Changelog

As mentioned on [the credits page](/credits), this whole thing is open source, so feel free to check out [the repo](https://github.com/maxjacobson/seasoning) on GitHub.

But here's some highlights of when things happened.

1. **February 23, 2025** — Humans can unfollow each other
1. **February 17, 2025** — Start the process of removing React from the frontend
1. **July 30, 2023** — On show page, you can hover on the checkbox to see how many episodes have been watched for each season
1. **June 29, 2023** — Update data refresh so that shows which are ongoing will refresh daily, and shows that are complete will refresh every 1-2 weeks, ish
1. **June 25, 2023** — Blockquotes in rendered markdown are now styled as blockquotes, with a left border
1. **June 25, 2023** — Some more spacing between paragraphs in rendered markdown
1. **May 22, 2023** — Basic pagination on the "Your shows" page to only show 10 shows at a time
1. **May 22, 2023** — Humans can now remove a show from their "Your shows" list entirely. Seasoning will forget your "note to self" and the assigned status. It will still remember which episodes you've checked off that you've seen, and your season reviews.
1. **April 17, 2023** — Humans can optionally set a limit on how many shows they are currently watching
1. **March 31, 2023** — Show "last refreshed at" show data on season page and episode page
1. **February 23, 2023** — Automatically toggle shows from "waiting for more" to "next up" _only when there is a new episode available to watch_, not just when the season is announced.
1. **February 23, 2023** — Add some animation to the global loading ribbon
1. **February 23, 2023** — Show future episode air dates in a fainter gray text color in episodes list on season page
1. **February 21, 2023** — Fix bug where episode air dates could be off by a day
1. **February 19, 2023** — Display when show data was last refreshed from TMDB
1. **February 15, 2023** — Ignore "The" and "A" at start of titles when sorting shows
1. **February 11, 2023** — Display show first aired year on search page
1. **February 11, 2023** — Add more info links to TMDB
1. **February 11, 2023** — Some restyling with Tailwind
1. **January 13, 2023** — Display episode air date on episode page and season page
1. **January 13, 2023** — Made background refreshing of episodes more resilient, so if one show cannot refresh it doesn't prevent other shows from refreshing
1. **January 13, 2023** — Set up bugsnag for exception tracking for backend ruby errors
1. **January 7, 2023** — Change the default setting for new people who sign up so that their currently viewing shows will be publicly viewable.
1. **January 7, 2023** — New page for individual episodes
1. **January 7, 2023** — People can mark individual episodes as seen
1. **January 7, 2023** — start recording episode details in database
1. **December 24, 2022** — add following and followers page to profiles
1. **December 24, 2022** — add simple admin page with some basic stats
1. **December 24, 2022** — add [changelog page](/changelog) and [roadmap page](/roadmap)
1. **December 24, 2022** — limit [the reviews page](/reviews) to your own reviews, and reviews from people you follow
1. **December 24, 2022** — limit [an individual's reviews page](/maxjacobson/reviews) to 10 recent reviews
1. **December 24, 2022** — limit [the reviews page](/reviews) to 10 recent reviews
1. **December 24, 2022** — limit [the reviews page](/reviews) to authenticated guests
1. **December 19, 2022** — Order shows on homepage by title and status, not just status
1. **June 18, 2022** — Magic links are now more flexibile, and will work even if you type your email with mixed case or trailing spaces
1. **June 18, 2022** — People can delete their reviews
1. **June 18, 2022** — When filtering homepage, save the filters in the URL so they can be sticky
1. **June 18, 2022** — Show the note to self on the homepage
1. **May 22, 2022** — Make it possible to import two shows with the same name, for remakes etc
1. **April 4, 2022** — Improve experience when importing shows
1. **November 5, 2021** — Improve show import flow by doing a search and letting you pick the one you actually definitely want
1. **October 24, 2021** — Add new "next up" show status, and automatically move shows into that status when a new season is available
1. **October 10, 2021** — Redesign to stop using [Shopify's Polaris design system](https://polaris.shopify.com/) but, rather, just use a really small handful of lines of CSS
1. **May 1, 2021** — Display season-specific posters
1. **April 26, 2021** — People can set their default review visibility for new reviews
1. **April 25, 2021** — People can tick off which seasons of shows that they've seen from the show page
1. **April 25, 2021** — Link to profile page from review page
1. **April 11, 2021** — [first review](/maxjacobson/shows/the-man-in-the-high-castle/season-1) is posted
1. **April 11, 2021** — Show global feed of reviews on [reviews page](/reviews)
1. **April 10, 2021** — People can write reviews of seasons of shows, with star ratings, text, and visibility
1. **April 10, 2021** — People can follow each other
1. **April 10, 2021** — People can choose whether or not to show their currently watching shows on their profile page
1. **April 10, 2021** — People can filter the homepage by show status
1. **April 5, 2021** — People can tick off which seasons of shows that they've seen
1. **April 4, 2021** — People can indicate the status of their relationship to a show (currently watching, waiting for more, etc)
1. **April 4, 2021** — Display show posters
1. **March 28, 2021** — Added a navbar
1. **March 27, 2021** — Switch from Wikipedia to TMDB as the source of data
1. **March 21, 2021** — People can search for shows
1. **March 14, 2021** — People can add "note to self" about a show
1. **March 13, 2021** — People can add shows they're interested in
1. **March 9, 2021** — Development starts
