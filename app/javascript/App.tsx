import React, { FunctionComponent, useState } from "react"
import { Link as ReachLink, Router, navigate } from "@reach/router"

import { AppProvider, Frame, Loading, TopBar, Icon, VisuallyHidden } from "@shopify/polaris"
import { LogOutMinor, InfoMinor, QuestionMarkMajor } from "@shopify/polaris-icons"
import { LinkLikeComponentProps } from "@shopify/polaris/dist/types/latest/src/utilities/link"
import enTranslations from "@shopify/polaris/locales/en.json"
import "@shopify/polaris/dist/styles.css"

import { Guest } from "./types"
import Logo from "./images/logo.svg"

// Pages
import NotFound from "./pages/NotFound"
import Home from "./pages/Home"
import AddShow from "./pages/AddShow"
import Show from "./pages/Show"
import Profile from "./pages/Profile"
import RedeemMagicLink from "./pages/RedeemMagicLink"
import Credits from "./pages/Credits"

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
    <ReachLink to={url} id={id} className={className} onClick={onClick}>
      {children}
    </ReachLink>
  )
}

interface Props {
  initialGuest: Guest
}

const App: FunctionComponent<Props> = ({ initialGuest }: Props) => {
  const [guest, setGuest] = useState<Guest>(initialGuest)
  const [loading, setLoading] = useState(false)
  const [userMenuOpen, setUserMenuOpen] = useState(false)
  const [isSecondaryMenuOpen, setIsSecondaryMenuOpen] = useState(false)

  return (
    <>
      <AppProvider
        i18n={enTranslations}
        linkComponent={CustomLink}
        theme={{
          logo: {
            topBarSource: Logo,
            url: "/",
            accessibilityLabel: "Seasoning",
            width: 160,
          },
        }}
      >
        <Frame
          topBar={
            <TopBar
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
            />
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
            <AddShow path="/add-show" guest={guest} setLoading={setLoading} />
            <Show path="/shows/:showSlug" guest={guest} setLoading={setLoading} />
            <Credits path="/credits" />
            <Profile path="/:handle" setLoading={setLoading} />
          </Router>
        </Frame>
      </AppProvider>
    </>
  )
}

export default App
