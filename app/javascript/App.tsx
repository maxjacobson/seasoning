import React, { useState, useEffect } from "react"
import { Link, Router, RouteComponentProps, navigate } from "@reach/router"
import styled, { createGlobalStyle } from "styled-components"

import { AnonymousGuest, AuthenticatedGuest, Guest } from "./types"
import NotFound from "./pages/NotFound"
import Home from "./pages/Home"
import Discover from "./pages/Discover"
import Profile from "./pages/Profile"
import RedeemMagicLink from "./pages/RedeemMagicLink"

const GlobalStyle = createGlobalStyle`
  body {
    margin: 0;
    padding: 0;
    font-family: sans-serif;
    background-color: #edfff2;
  }
`

const Layout = styled.div`
  max-width: 450px;
  margin: 10px auto;

  a {
    color: #1d2b8a;
    text-decoration: none;
    font-weight: bold;
    background-color: yellow;
    &:hover {
      color: green;
    }
  }
`

const App = () => {
  const [guestToken, setGuestToken] = useState<string | null>(
    localStorage.getItem("oiva-guest-token")
  )
  const [guest, setGuest] = useState<Guest | undefined>(undefined)

  useEffect(() => {
    if (!guestToken) {
      setGuest({} as AnonymousGuest)
      return
    }

    fetch("/api/guest.json", { headers: { "X-OIVA-TOKEN": guestToken } })
      .then((response) => response.json())
      .then((data: AuthenticatedGuest) => setGuest(data))
  }, [guestToken])

  return (
    <Layout>
      <GlobalStyle />

      <nav>
        <Link to="/">Home</Link> <Link to="/discover">Discover</Link>{" "}
        {guest && guest.authenticated && (
          <>
            <Link to={`/${guest.human.handle}`}>{guest.human.handle}</Link>{" "}
            <a
              href="#"
              onClick={(e) => {
                e.preventDefault()
                localStorage.clear()
                setGuestToken(null)
                navigate("/")
              }}
            >
              Log out
            </a>
          </>
        )}
      </nav>

      <Router>
        <NotFound default />
        <Home path="/" guest={guest} />
        <Discover path="/discover" guest={guest} />
        <RedeemMagicLink path="/knock-knock/:token" setToken={setGuestToken} />
        <Profile path="/:handle" guest={guest} />
      </Router>
    </Layout>
  )
}

export default App
