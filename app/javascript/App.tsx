import React, { FunctionComponent, useState, useEffect } from "react"
import { Link as ReachLink, Router, navigate, Location } from "@reach/router"
import debounce from "lodash.debounce"

import {
  AppProvider,
  Frame,
  Loading,
  TopBar,
  Icon,
  VisuallyHidden,
  ActionList,
  Navigation,
} from "@shopify/polaris"
import {
  LogOutMinor,
  InfoMinor,
  QuestionMarkMajor,
  ViewMinor,
  SettingsMajor,
} from "@shopify/polaris-icons"
import { LinkLikeComponentProps } from "@shopify/polaris/dist/types/latest/src/utilities/link"
import enTranslations from "@shopify/polaris/locales/en.json"
import "@shopify/polaris/dist/styles.css"

import { Guest, Show, ShallowShow, AuthenticatedGuest } from "./types"
import LogoWithName from "./images/logo-with-name.svg"

// Pages
import NotFound from "./pages/NotFound"
import Home from "./pages/Home"
import YourShowsPage from "./pages/YourShowsPage"
import ShowPage from "./pages/ShowPage"
import SeasonPage from "./pages/SeasonPage"
import Profile from "./pages/Profile"
import RedeemMagicLink from "./pages/RedeemMagicLink"
import Credits from "./pages/Credits"
import Settings from "./pages/Settings"
import SeasonReviewPage from "./pages/SeasonReviewPage"

const createCustomLink = (closeMobileMenu: () => void) => {
  // Wires @reach/router up to @shopify/polaris.
  // We'll just use the link component from polaris, and it will use this.
  const CustomLink = ({
    children,
    url,
    className,
    id,
    onClick,
    external,
    ..._rest
  }: LinkLikeComponentProps) => {
    if (external) {
      return (
        <a id={id} className={className} href={url} target="_blank" rel="noreferrer">
          {children}
        </a>
      )
    } else {
      return (
        <ReachLink
          to={url}
          id={id}
          className={className}
          onClick={(e) => {
            closeMobileMenu()
            onClick && onClick(e)
          }}
        >
          {children}
        </ReachLink>
      )
    }
  }

  return CustomLink
}

const searchForShows = (
  title: string,
  token: string,
  setLoading: (loadingState: boolean) => void,
  callback: (shows: ShallowShow[]) => void
) => {
  setLoading(true)

  fetch(`/api/shows.json?q=${encodeURIComponent(title)}`, {
    headers: {
      "X-SEASONING-TOKEN": token,
    },
  })
    .then((response) => {
      setLoading(false)
      if (response.ok) {
        return response.json()
      } else {
        throw new Error("Could not search shows")
      }
    })
    .then((data) => {
      callback(data.shows)
    })
}
const debouncedSearch = debounce(searchForShows, 400, { trailing: true })

interface NoSearchYet {
  shows: null
}

interface SearchResultsLoaded {
  shows: ShallowShow[]
}

type SearchResults = NoSearchYet | SearchResultsLoaded

interface ShowSearchResultsProps {
  shows: ShallowShow[]
  setSearchQuery: (newQuery: string) => void
  guest: AuthenticatedGuest
  globalSetLoading: (loadingState: boolean) => void
}

const ShowSearchResults: FunctionComponent<ShowSearchResultsProps> = ({
  shows,
  setSearchQuery,
  guest,
  globalSetLoading,
}: ShowSearchResultsProps) => {
  if (shows.length) {
    return (
      <ActionList
        items={shows.map((show) => {
          return {
            content: show.title,
            onAction: async () => {
              setSearchQuery("")
              if (show.imported) {
                navigate(`/shows/${show.slug}`)
              } else {
                globalSetLoading(true)
                const response = await fetch("/api/shows.json", {
                  body: JSON.stringify({
                    shows: {
                      tmdb_id: show.tmdb_id,
                    },
                  }),
                  method: "POST",
                  headers: {
                    "X-SEASONING-TOKEN": guest.token,
                    "Content-Type": "application/json",
                  },
                })
                globalSetLoading(false)

                if (response.ok) {
                  const data: { show: Show } = await response.json()
                  navigate(`/shows/${data.show.slug}`)
                } else {
                  throw new Error("Could not import show")
                }
              }
            },
          }
        })}
      />
    )
  } else {
    return (
      <ActionList
        items={[
          {
            content: "No matches",
          },
        ]}
      />
    )
  }
}

interface Props {
  initialGuest: Guest
}

const App: FunctionComponent<Props> = ({ initialGuest }: Props) => {
  const [guest, setGuest] = useState<Guest>(initialGuest)
  const [loading, setLoading] = useState(false)
  const [userMenuOpen, setUserMenuOpen] = useState(false)
  const [isSecondaryMenuOpen, setIsSecondaryMenuOpen] = useState(false)
  const [searchQuery, setSearchQuery] = useState("")
  const [searchResults, setSearchResults] = useState<SearchResults>({
    shows: null,
  })
  const [mobileNavigationActive, setMobileNavigationActive] = useState(false)
  const [currentModal, setCurrentModal] = useState<React.ReactNode | null>(null)

  useEffect(() => {
    if (!searchQuery || !guest.authenticated) {
      setSearchResults({ shows: null })
    } else {
      debouncedSearch(searchQuery, guest.token, setLoading, (shows) => {
        setSearchResults({ shows: shows })
      })
    }

    return debouncedSearch.cancel
  }, [searchQuery, guest])

  return (
    <>
      <Location>
        {({ location }) => (
          <AppProvider
            i18n={enTranslations}
            linkComponent={createCustomLink(() => setMobileNavigationActive(false))}
            theme={{
              logo: {
                topBarSource: LogoWithName,
                accessibilityLabel: "Seasoning",
                width: 160,
                url: guest.authenticated ? "/shows" : "/",
              },
            }}
          >
            <Frame
              showMobileNavigation={mobileNavigationActive}
              onNavigationDismiss={() => setMobileNavigationActive(!mobileNavigationActive)}
              topBar={
                <TopBar
                  showNavigationToggle
                  onNavigationToggle={() => setMobileNavigationActive(!mobileNavigationActive)}
                  userMenu={
                    guest.authenticated && (
                      <TopBar.UserMenu
                        name={guest.human.handle}
                        initials={guest.human.handle.charAt(0)}
                        avatar={guest.human.gravatar_url}
                        open={userMenuOpen}
                        onToggle={() => {
                          setUserMenuOpen(!userMenuOpen)
                        }}
                        actions={[
                          {
                            items: [
                              {
                                content: "Your page",
                                url: `/${guest.human.handle}`,
                                icon: InfoMinor,
                              },
                              {
                                content: "Settings",
                                url: "/settings",
                                icon: SettingsMajor,
                              },
                              {
                                content: "Log out",
                                onAction: () => {
                                  if (confirm("Log out?")) {
                                    localStorage.clear()
                                    setGuest({ authenticated: false })
                                    navigate("/")
                                  }
                                },
                                icon: LogOutMinor,
                              },
                            ],
                          },
                        ]}
                      />
                    )
                  }
                  secondaryMenu={
                    <TopBar.Menu
                      activatorContent={
                        <span>
                          <Icon source={QuestionMarkMajor} />
                          <VisuallyHidden>Secondary menu</VisuallyHidden>
                        </span>
                      }
                      open={isSecondaryMenuOpen}
                      onOpen={() => setIsSecondaryMenuOpen(!isSecondaryMenuOpen)}
                      onClose={() => setIsSecondaryMenuOpen(!isSecondaryMenuOpen)}
                      actions={[
                        {
                          items: [
                            {
                              content: "Credits",
                              url: "/credits",
                            },
                          ],
                        },
                      ]}
                    />
                  }
                  searchField={
                    guest.authenticated && (
                      <TopBar.SearchField
                        value={searchQuery}
                        onChange={setSearchQuery}
                        placeholder="Search shows"
                      />
                    )
                  }
                  searchResults={
                    searchResults.shows &&
                    guest.authenticated && (
                      <ShowSearchResults
                        shows={searchResults.shows}
                        setSearchQuery={setSearchQuery}
                        globalSetLoading={setLoading}
                        guest={guest}
                      />
                    )
                  }
                  searchResultsVisible={true}
                />
              }
              navigation={
                <Navigation location={location.pathname}>
                  <Navigation.Section
                    items={
                      guest.authenticated
                        ? [
                            {
                              label: "Shows",
                              icon: ViewMinor,
                              url: "/shows",
                            },
                          ]
                        : []
                    }
                  />
                </Navigation>
              }
            >
              {loading && <Loading />}

              <Router>
                <NotFound default />
                <Home path="/" guest={guest} setLoading={setLoading} />
                <YourShowsPage path="/shows" guest={guest} setLoading={setLoading} />
                <RedeemMagicLink
                  path="/knock-knock/:token"
                  setGuest={setGuest}
                  setLoading={setLoading}
                />
                <ShowPage path="/shows/:showSlug" guest={guest} setLoading={setLoading} />
                <SeasonPage
                  path="/shows/:showSlug/:seasonSlug"
                  guest={guest}
                  setLoading={setLoading}
                  setCurrentModal={setCurrentModal}
                />
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
                <Credits path="/credits" />
                <Settings path="/settings" setLoading={setLoading} guest={guest} />
                <Profile path="/:handle" guest={guest} setLoading={setLoading} />
              </Router>

              {currentModal}
            </Frame>
          </AppProvider>
        )}
      </Location>
    </>
  )
}

export default App
