import React, { FunctionComponent, useState, useEffect } from "react"
import { Link as ReachLink, Router, navigate } from "@reach/router"
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
  StarFilledMinor,
} from "@shopify/polaris-icons"
import { LinkLikeComponentProps } from "@shopify/polaris/dist/types/latest/src/utilities/link"
import enTranslations from "@shopify/polaris/locales/en.json"
import "@shopify/polaris/dist/styles.css"

import { Guest, Show } from "./types"
import Logo from "./images/logo.svg"

// Pages
import NotFound from "./pages/NotFound"
import Home from "./pages/Home"
import ShowPage from "./pages/Show"
import Profile from "./pages/Profile"
import RedeemMagicLink from "./pages/RedeemMagicLink"
import Credits from "./pages/Credits"

import ImportNewShowModal from "./components/ImportNewShowModal"

const createCustomLink = (closeMobileMenu: () => void) => {
  // Wires @reach/router up to @shopify/polaris.
  // We'll just use the link component from polaris, and it will use this.
  const CustomLink = ({
    children,
    url,
    className,
    id,
    onClick,
    ..._rest
  }: LinkLikeComponentProps) => {
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

  return CustomLink
}

const searchForShows = (
  title: string,
  token: string,
  setLoading: (loadingState: boolean) => void,
  callback: (shows: Show[]) => void
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
  shows: Show[]
}

type SearchResults = NoSearchYet | SearchResultsLoaded

interface ShowSearchResultsProps {
  shows: Show[]
  setSearchQuery: (newQuery: string) => void
  initiateImport: () => void
}

const ShowSearchResults: FunctionComponent<ShowSearchResultsProps> = ({
  shows,
  setSearchQuery,
  initiateImport,
}: ShowSearchResultsProps) => {
  if (shows.length) {
    return (
      <ActionList
        items={shows.map((show) => {
          return {
            content: show.title,
            onAction: () => {
              setSearchQuery("")
              navigate(`/shows/${show.slug}`)
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
            content: "Add show?",
            onAction: () => {
              setSearchQuery("")
              initiateImport()
            },
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
  const [modalActive, setModalActive] = useState(false)
  const [mobileNavigationActive, setMobileNavigationActive] = useState(false)

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
      <AppProvider
        i18n={enTranslations}
        linkComponent={createCustomLink(() => setMobileNavigationActive(false))}
        theme={{
          logo: {
            topBarSource: Logo,
            accessibilityLabel: "Seasoning",
            width: 160,
            url: "/",
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
                            onAction: () => {
                              navigate(`/${guest.human.handle}`)
                            },
                            icon: InfoMinor,
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
                          onAction: () => {
                            navigate("/credits")
                          },
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
                searchResults.shows && (
                  <ShowSearchResults
                    shows={searchResults.shows}
                    setSearchQuery={setSearchQuery}
                    initiateImport={() => setModalActive(true)}
                  />
                )
              }
              searchResultsVisible={true}
            />
          }
          navigation={
            <Navigation location="/">
              <Navigation.Section
                items={[
                  {
                    label: "Currently watching",
                    onClick: () => {
                      alert("Not implemented yet")
                    },
                    icon: ViewMinor,
                  },
                  {
                    label: "Your favorite shows",
                    onClick: () => {
                      alert("stand by...")
                    },
                    icon: StarFilledMinor,
                  },
                ]}
              />
            </Navigation>
          }
        >
          {loading && <Loading />}

          <Router>
            <NotFound default />
            <Home path="/" guest={guest} setLoading={setLoading} />
            <RedeemMagicLink
              path="/knock-knock/:token"
              setGuest={setGuest}
              setLoading={setLoading}
            />
            <ShowPage path="/shows/:showSlug" guest={guest} setLoading={setLoading} />
            <Credits path="/credits" />
            <Profile path="/:handle" setLoading={setLoading} />
          </Router>

          {guest.authenticated && (
            <ImportNewShowModal
              token={guest.token}
              globalSetLoading={setLoading}
              active={modalActive}
              setActive={setModalActive}
            />
          )}
        </Frame>
      </AppProvider>
    </>
  )
}

export default App
