import React, { FunctionComponent, useState } from "react"
import { BrowserRouter, Link, Route, Routes, useNavigate, useSearchParams } from "react-router-dom"
import { Global, css } from "@emotion/react"
import styled from "@emotion/styled"

import { Guest, Show } from "./types"

// Pages
import { NotFoundPage } from "./pages/NotFoundPage"
import { HomePage } from "./pages/HomePage"
import { YourShowsPage } from "./pages/YourShowsPage"
import { ShowPage } from "./pages/ShowPage"
import { SeasonPage } from "./pages/SeasonPage"
import { ProfilePage } from "./pages/ProfilePage"
import { ProfileReviewsPage } from "./pages/ProfileReviewsPage"
import { RedeemMagicLinkPage } from "./pages/RedeemMagicLinkPage"
import { CreditsPage } from "./pages/CreditsPage"
import { SettingsPage } from "./pages/SettingsPage"
import { SeasonReviewPage } from "./pages/SeasonReviewPage"
import { ReviewsFeedPage } from "./pages/ReviewsFeedPage"
import { NewSeasonReviewPage } from "./pages/NewSeasonReviewPage"
import { ImportShowPage } from "./pages/ImportShowPage"
import { SearchResultsPage } from "./pages/SearchResultsPage"

import { LoadingRibbon } from "./components/LoadingRibbon"
import { ShowSearchBar } from "./components/ShowSearchBar"

import LogoWithName from "./images/logo-with-name.svg"

const globalStyles = css`
  body {
    padding: 0;
    margin: 0;
    font-family: monospace;
  }
`

const SiteHeader = styled.div`
  margin: 10px 5px;
  display: flex;
  justify-content: space-between;
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
      <Global styles={globalStyles} />
      <>
        <LoadingRibbon loading={loading} />

        <SiteHeader>
          <div style={{ display: "flex" }}>
            <Link to="/">
              <img src={LogoWithName} />
            </Link>
            {guest.authenticated && (
              <ShowSearchBar
                guest={guest}
                setLoading={setLoading}
                callback={setSearchResults}
                query={searchQuery}
                setQuery={(newSearchQuery) => setSearchParams({ q: newSearchQuery })}
              />
            )}
          </div>
          <div>
            <Link to="/reviews">Reviews</Link>
            <span> * </span>
            <Link to="/credits">Credits</Link>

            {guest.authenticated && (
              <>
                <span> * </span>
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
            <Route path="/" element={<HomePage guest={guest} setLoading={setLoading} />} />

            <Route
              path="/shows"
              element={<YourShowsPage guest={guest} setLoading={setLoading} />}
            />
            <Route
              path="/knock-knock/:token"
              element={<RedeemMagicLinkPage setGuest={setGuest} setLoading={setLoading} />}
            />
            <Route
              path="/shows/:showSlug"
              element={<ShowPage guest={guest} setLoading={setLoading} />}
            />
            <Route
              path="/shows/:showSlug/:seasonSlug"
              element={<SeasonPage guest={guest} setLoading={setLoading} />}
            />
            <Route
              path="/:handle/shows/:showSlug/:seasonSlug"
              element={<SeasonReviewPage guest={guest} setLoading={setLoading} />}
            />
            <Route
              path="/:handle/shows/:showSlug/:seasonSlug/:viewing"
              element={<SeasonReviewPage guest={guest} setLoading={setLoading} />}
            />

            <Route
              path="/reviews"
              element={<ReviewsFeedPage guest={guest} setLoading={setLoading} />}
            />
            <Route path="/credits" element={<CreditsPage />} />
            <Route
              path="/settings"
              element={<SettingsPage setLoading={setLoading} guest={guest} />}
            />
            <Route
              path="/import-show"
              element={<ImportShowPage guest={guest} setLoading={setLoading} />}
            />
            <Route
              path="/:handle"
              element={<ProfilePage guest={guest} setLoading={setLoading} />}
            />
            <Route
              path="/:handle/reviews"
              element={<ProfileReviewsPage guest={guest} setLoading={setLoading} />}
            />
            <Route
              path="/shows/:showSlug/:seasonSlug/reviews/new"
              element={<NewSeasonReviewPage guest={guest} setLoading={setLoading} />}
            />
            <Route path="/search" element={<SearchResultsPage searchResults={searchResults} />} />
            <Route path="*" element={<NotFoundPage />} />
          </Routes>
        </SiteBody>
      </>
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
