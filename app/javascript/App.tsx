import "./App.css"

import { BrowserRouter, Link, Route, Routes, useNavigate, useSearchParams } from "react-router-dom"
import { Guest, Show } from "./types"
import { GuestContext, SetLoadingContext } from "./contexts"
import React, { FunctionComponent, useState } from "react"
import { AdminPage } from "./pages/AdminPage"
import { ChangelogPage } from "./pages/ChangelogPage"
import { CreditsPage } from "./pages/CreditsPage"
import { EpisodePage } from "./pages/EpisodePage"
import { HomePage } from "./pages/HomePage"
import { ImportShowPage } from "./pages/ImportShowPage"
import { LoadingRibbon } from "./components/LoadingRibbon"
import LogoWithName from "./images/logo-with-name.svg"
import { NewSeasonReviewPage } from "./pages/NewSeasonReviewPage"
import { NotFoundPage } from "./pages/NotFoundPage"
import { ProfileFollowersPage } from "./pages/ProfileFollowersPage"
import { ProfileFollowingPage } from "./pages/ProfileFollowingPage"
import { ProfilePage } from "./pages/ProfilePage"
import { ProfileReviewsPage } from "./pages/ProfileReviewsPage"
import { RedeemMagicLinkPage } from "./pages/RedeemMagicLinkPage"
import { ReviewsFeedPage } from "./pages/ReviewsFeedPage"
import { RoadmapPage } from "./pages/RoadmapPage"
import { SearchResultsPage } from "./pages/SearchResultsPage"
import { SeasonPage } from "./pages/SeasonPage"
import { SeasonReviewPage } from "./pages/SeasonReviewPage"
import { SettingsPage } from "./pages/SettingsPage"
import { ShowPage } from "./pages/ShowPage"
import { ShowSearchBar } from "./components/ShowSearchBar"
import { YourShowsPage } from "./pages/YourShowsPage"

interface Props {
  initialGuest: Guest
}

const App: FunctionComponent<Props> = ({ initialGuest }: Props) => {
  const [guest, setGuest] = useState<Guest>(initialGuest)
  const [loading, setLoading] = useState(false)
  const [searchResults, setSearchResults] = useState<Show[] | null>(null)
  const navigate = useNavigate()
  const [searchParams, setSearchParams] = useSearchParams()
  const searchQuery = searchParams.get("q") || ""

  return (
    <>
      <GuestContext.Provider value={guest}>
        <SetLoadingContext.Provider value={setLoading}>
          <>
            <LoadingRibbon loading={loading} />

            <div className="my-2 mx-1 flex flex-col justify-between md:flex-row">
              <div className="flex flex-col md:flex-row">
                <Link to="/">
                  <img src={LogoWithName} className="h-full" />
                </Link>
                {guest.authenticated && (
                  <ShowSearchBar
                    guest={guest}
                    callback={setSearchResults}
                    query={searchQuery}
                    setQuery={(newSearchQuery) => setSearchParams({ q: newSearchQuery })}
                  />
                )}
              </div>
              <div className="pr-2">
                {guest.authenticated && (
                  <>
                    <Link to={`/${guest.human.handle}`} className="mr-2">
                      Your page
                    </Link>
                    <Link to="/settings" className="mr-2">
                      Settings
                    </Link>
                    <a
                      href="#"
                      onClick={() => {
                        if (confirm("Log out?")) {
                          localStorage.clear()
                          setGuest({ authenticated: false })
                          navigate("/")
                        }
                      }}
                    >
                      Log out
                    </a>
                  </>
                )}
              </div>
            </div>

            <div className="my-0 mx-auto max-w-2xl p-2">
              <Routes>
                <Route path="/" element={<HomePage />} />

                <Route path="/shows" element={<YourShowsPage />} />
                <Route
                  path="/knock-knock/:token"
                  element={<RedeemMagicLinkPage setGuest={setGuest} />}
                />
                <Route path="/shows/:showSlug" element={<ShowPage />} />
                <Route path="/shows/:showSlug/:seasonSlug" element={<SeasonPage />} />
                <Route
                  path="/shows/:showSlug/:seasonSlug/:episodeNumber"
                  element={<EpisodePage />}
                />
                <Route path="/:handle/shows/:showSlug/:seasonSlug" element={<SeasonReviewPage />} />
                <Route
                  path="/:handle/shows/:showSlug/:seasonSlug/:viewing"
                  element={<SeasonReviewPage />}
                />

                <Route path="/reviews" element={<ReviewsFeedPage />} />
                <Route path="/credits" element={<CreditsPage />} />
                <Route path="/settings" element={<SettingsPage />} />
                <Route path="/import-show" element={<ImportShowPage />} />
                <Route path="/changelog" element={<ChangelogPage />} />
                <Route path="/roadmap" element={<RoadmapPage />} />
                <Route path="/admin" element={<AdminPage />} />
                <Route path="/:handle" element={<ProfilePage />} />
                <Route path="/:handle/reviews" element={<ProfileReviewsPage />} />
                <Route path="/:handle/following" element={<ProfileFollowingPage />} />
                <Route path="/:handle/followers" element={<ProfileFollowersPage />} />
                <Route
                  path="/shows/:showSlug/:seasonSlug/reviews/new"
                  element={<NewSeasonReviewPage />}
                />
                <Route
                  path="/search"
                  element={<SearchResultsPage searchResults={searchResults} />}
                />
                <Route path="*" element={<NotFoundPage />} />
              </Routes>

              <div className="mt-5 flex justify-evenly border-t border-dashed border-t-black">
                {guest.authenticated && guest.human.admin && (
                  <>
                    {" "}
                    <Link to="/admin">Admin</Link>
                  </>
                )}
                {guest.authenticated && (
                  <>
                    <Link to="/reviews">Reviews</Link>{" "}
                  </>
                )}
                <Link to="/roadmap">Roadmap</Link> <Link to="/changelog">Changelog</Link>{" "}
                <Link to="/credits">Credits</Link>
              </div>
            </div>
          </>
        </SetLoadingContext.Provider>
      </GuestContext.Provider>
    </>
  )
}

export const AppWithRouter: FunctionComponent<Props> = (props) => {
  return (
    <BrowserRouter>
      <App {...props} />
    </BrowserRouter>
  )
}
