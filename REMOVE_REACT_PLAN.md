# Plan to remove React from Seasoning

## The tedious part

- [x] Make it possible to build some pages with vanilla ERB, still with access to tailwind
- [x] Port the sign up / sign-in flow
- [x] Confirm that this can deploy to heroku without issue
- [x] Port /shows (YourShowsPage)
- [x] Port /shows/:showSlug (ShowPage)
- [x] Port /shows/:showSlug/:seasonSlug (SeasonPage)
- [x] Port /shows/:showSlug/:seasonSlug/reviews/new (NewSeasonReviewPage)
- [x] Port /shows/:showSlug/:seasonSlug/:episodeNumber (EpisodePage)
- [x] Port /:handle/shows/:showSlug/:seasonSlug (SeasonReviewPage)
- [x] Port /:handle/shows/:showSlug/:seasonSlug/:viewing (SeasonReviewPage)
- [x] Remove /reviews (ReviewsFeedPage)
- [x] Port /credits (CreditsPage)
- [x] Port /settings (SettingsPage)
- [x] Port /import-show (ImportShowPage)
- [x] Port /changelog (ChangelogPage)
- [x] Port /roadmap (RoadmapPage)
- [x] Port /admin (AdminPage)
- [x] Port /:handle (ProfilePage)
- [x] Port /:handle/reviews (ProfileReviewsPage)
- [x] Port /:handle/following (ProfileFollowingPage)
- [x] Port /:handle/followers (ProfileFollowersPage)
- [x] Port /search (SearchResultsPage)
- [x] Review all of the FIXMEs

## The fun part

- [ ] Remove unused JavaScript dependencies (react, vite, etc)
- [ ] Remove API endpoints
- [ ] Remove JSON serializer classes
- [ ] remove unused Ruby dependencies (`vite_rails`, `oj_serializers`)
- [ ] Add turbolinks to make it fast again?
