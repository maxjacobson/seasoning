# Changelog

As mentioned on [the credits page](/credits), this whole thing is open source, so feel free to check out [the repo](https://github.com/maxjacobson/seasoning) on GitHub.

But here's some highlights of when things happened.

1. **November 19, 2025** — Fix new season detection to respect your time zone: previously, checking for unwatched seasons used the server's time zone to determine if episodes had aired, which could incorrectly show episodes as available before they've actually aired in your location
1. **November 16, 2025** — Reserve vertical space for flash messages to prevent content shifting when navigating between pages with and without flash messages
1. **November 9, 2025** — Add ability to skip seasons: mark individual seasons as skipped to exclude them from progress calculations and available episodes badges. Perfect for jumping into a show at a specific season (like watching only the latest season of Dancing with the Stars). Skipped seasons hide their progress bars and disable episode checkboxes. Skipped seasons won't trigger "next up" notifications or status changes when new episodes are released
1. **November 8, 2025** — Redesigned seasons list on show page: replaced table layout with a responsive grid showing season posters with available episodes badges. Click any poster to view that season's details
1. **November 8, 2025** — Available episodes badge: Red notification badges now appear on show cards showing how many unwatched episodes are available to watch. Badges overhang the poster in the top-right corner like iOS app notifications. Shows "…" if 10+ episodes are available, and hover tooltips display the full count
1. **November 7, 2025** — Improved search experience: search now prioritizes results from your library first, and only hits the TMDB API if you need additional results. When your library has matching shows, you'll see a "Include results from TMDB" link at the bottom to expand the search
1. **November 3, 2025** — Improve new season checker to notify you when shows you've added (but haven't watched) finally have aired episodes
1. **October 31, 2025** — Episode checkbox now keeps you on the episode page instead of redirecting to the season page
1. **October 19, 2025** — Season review textareas now auto-expand to fit content as you type, matching the behavior of note-to-self textareas
1. **October 9, 2025** — Display season reviews in card format on season pages showing author username, star rating, and date instead of just date links
1. **October 6, 2025** — Add in-app notifications for returning shows: when the daily checker detects new seasons for shows you're waiting for or have finished, you'll see dismissible "[Show Name] is back!" banners on every page
1. **September 28, 2025** — Add collapsible note-to-self sections with clickable caret arrows for easier reading
1. **September 28, 2025** — Add Cmd+Enter (Mac) and Ctrl+Enter (Windows/Linux) keyboard shortcuts to submit forms when focused on textareas
1. **September 11, 2025** — Improve profile page design with horizontal navigation menu for reviews/stats links, friendlier join date formatting, and currently watching show count display
1. **September 6, 2025** — Add season progress bars to individual season pages showing percentage of episodes watched in that season
1. **September 6, 2025** — Add toggle to stats pages allowing users to view seasons reviewed during a year vs seasons that originally aired during a year, providing richer insights into viewing habits
1. **August 24, 2025** — Can mark episodes as seen from the episode show page
1. **August 24, 2025** — Add personal stats pages showing year-by-year review statistics with top 25 favorite seasons. Available at `/your-handle/stats` with year navigation.
1. **August 17, 2025** — Auto-link links in markdown text fields
1. **August 16, 2025** — Show "added by X people" counts on search page for shows that have already been imported
1. **August 16, 2025** — Apply consistent card-based design to shows index page
1. **July 14, 2025** — Add watch progress bars showing percentage of episodes watched for each show on both the shows index and individual show pages
1. **July 12, 2025** — Unified search and import experience: Search now queries TMDB directly and shows importable shows alongside imported ones, eliminating the separate import page
1. **July 9, 2025** — Show lock emoji on private reviews with tooltip explaining visibility
1. **July 9, 2025** — Add ability to edit season reviews (body, rating, visibility)
1. **July 8, 2025** — Improve design of reviews page to make it easier to scan (remove redundant author names, add visual separation, show dates, better layout)
1. **July 8, 2025** — Fix pagination on shows page so "Next" button only appears when there are actually more pages
1. **July 8, 2025** — Add pagination to your list of reviews
1. **April 13, 2025** — Admins can click "refresh now" button shows page
1. **April 13, 2025** — Remove ability to mark an entire season as seen from the seasons list on the show page
1. **April 13, 2025** — Remove "mutual followers" option from review visibility (it never worked) (sorry)
1. **February 27, 2025** — Allow searching by note to self, not just title
1. **February 27, 2025** — Show 30 shows/reviews per page instead of 10
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
1. **December 24, 2022** — limit the reviews page to your own reviews, and reviews from people you follow
1. **December 24, 2022** — limit [an individual's reviews page](/maxjacobson/reviews) to 10 recent reviews
1. **December 24, 2022** — limit the reviews page to 10 recent reviews
1. **December 24, 2022** — limit the reviews page to authenticated guests
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
1. **April 11, 2021** — Show global feed of reviews on reviews page
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
