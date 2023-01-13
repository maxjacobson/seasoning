import { BrowserRouter, Link, Route, Routes, useNavigate, useSearchParams } from "react-router-dom"
import { css, Global } from "@emotion/react"
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
import styled from "@emotion/styled"
import { YourShowsPage } from "./pages/YourShowsPage"

const globalStyles = css`
  body {
    padding: 0 0 20px 0;
    margin: 0;
    font-family: monospace;
  }

  a {
    color: #d67411;
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }
`

const SiteHeader = styled.div`
  margin: 10px 5px;
  display: flex;
  justify-content: space-between;

  @media (max-width: 800px) {
    flex-direction: column;
  }
`

const MobileFlex = styled.div`
  display: flex;
  @media (max-width: 800px) {
    flex-direction: column;
  }
`

const SiteBody = styled.div`
  max-width: 750px;
  margin: 0 auto;
`
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
          <Global styles={globalStyles} />
          <>
            <LoadingRibbon loading={loading} />

            <SiteHeader>
              <MobileFlex>
                <Link to="/">
                  <img src={LogoWithName} />
                </Link>
                {guest.authenticated && (
                  <ShowSearchBar
                    guest={guest}
                    callback={setSearchResults}
                    query={searchQuery}
                    setQuery={(newSearchQuery) => setSearchParams({ q: newSearchQuery })}
                  />
                )}
              </MobileFlex>
              <div>
                {guest.authenticated && (
                  <>
                    <Link to={`/${guest.human.handle}`}>Your page</Link>
                    <span> * </span>
                    <Link to="/settings">Settings</Link>
                    <span> * </span>
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
            </SiteHeader>

            <SiteBody>
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

              <div style={{ marginTop: "25px", borderTop: "1px dashed black" }}>
                {guest.authenticated && guest.human.admin && (
                  <>
                    {" "}
                    <Link to="/admin">Admin</Link> *{" "}
                  </>
                )}
                {guest.authenticated && (
                  <>
                    <Link to="/reviews">Reviews</Link> *{" "}
                  </>
                )}
                <Link to="/roadmap">Roadmap</Link> * <Link to="/changelog">Changelog</Link> *{" "}
                <Link to="/credits">Credits</Link>
              </div>
            </SiteBody>
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
