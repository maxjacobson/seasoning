import React, { FunctionComponent, useState } from "react"
import { Router, Link, navigate } from "@reach/router"
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

export const App: FunctionComponent<Props> = ({ initialGuest }: Props) => {
  const [guest, setGuest] = useState<Guest>(initialGuest)
  const [loading, setLoading] = useState(false)
  const [searchQuery, setSearchQuery] = useState("")
  const [searchResults, setSearchResults] = useState<Show[] | null>(null)

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
                setQuery={setSearchQuery}
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
          <Router>
            <NotFoundPage default />
            <HomePage path="/" guest={guest} setLoading={setLoading} />
            <YourShowsPage path="/shows" guest={guest} setLoading={setLoading} />
            <RedeemMagicLinkPage
              path="/knock-knock/:token"
              setGuest={setGuest}
              setLoading={setLoading}
            />
            <ShowPage path="/shows/:showSlug" guest={guest} setLoading={setLoading} />
            <SeasonPage path="/shows/:showSlug/:seasonSlug" guest={guest} setLoading={setLoading} />
            <SeasonReviewPage
              path="/:handle/shows/:showSlug/:seasonSlug"
              guest={guest}
              setLoading={setLoading}
            />
            <SeasonReviewPage
              path="/:handle/shows/:showSlug/:seasonSlug/:viewing"
              guest={guest}
              setLoading={setLoading}
            />
            <ReviewsFeedPage path="/reviews" guest={guest} setLoading={setLoading} />
            <CreditsPage path="/credits" />
            <SettingsPage path="/settings" setLoading={setLoading} guest={guest} />
            <ImportShowPage path="/import-show" guest={guest} setLoading={setLoading} />
            <ProfilePage path="/:handle" guest={guest} setLoading={setLoading} />
            <ProfileReviewsPage path="/:handle/reviews" guest={guest} setLoading={setLoading} />
            <NewSeasonReviewPage
              path="/shows/:showSlug/:seasonSlug/reviews/new"
              guest={guest}
              setLoading={setLoading}
            />
            <SearchResultsPage path="/search" searchResults={searchResults} />
          </Router>
        </SiteBody>
      </>
    </>
  )
}
