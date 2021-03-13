import React, { useState, useEffect } from "react"
import { Link, Router, navigate } from "@reach/router"
import styled, { createGlobalStyle } from "styled-components"

import { AnonymousGuest, AuthenticatedGuest, Guest } from "./types"
import NotFound from "./pages/NotFound"
import Home from "./pages/Home"
import About from "./pages/About"
import AddShow from "./pages/AddShow"
import Show from "./pages/Show"
import Profile from "./pages/Profile"
import RedeemMagicLink from "./pages/RedeemMagicLink"

const GlobalStyle = createGlobalStyle`
  body {
    margin: 0;
    padding: 0;
    font-family: sans-serif;
    background-color: #edfff2;
  }


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

const Layout = styled.div`
  max-width: 450px;
  margin: 10px auto;
  padding: 0 10px;
`

const Nav = styled.nav`
  display: flex;
  justify-content: space-between;
`

const App = () => {
  const [guestToken, setGuestToken] = useState<string | null>(
    localStorage.getItem("seasoning-guest-token")
  )
  const [guest, setGuest] = useState<Guest | undefined>(undefined)

  useEffect(() => {
    if (!guestToken) {
      setGuest({} as AnonymousGuest)
      return
    }

    fetch("/api/guest.json", { headers: { "X-SEASONING-TOKEN": guestToken } })
      .then((response) => response.json())
      .then((data: AuthenticatedGuest) => setGuest(data))
  }, [guestToken])

  return (
    <Layout>
      <GlobalStyle />

      <Nav>
        <span>
          <Link to="/">Seasoning</Link> <Link to="/about">About</Link>{" "}
        </span>

        <span>
          {guest && guest.authenticated && (
            <>
              <Link to={`/${guest.human.handle}`}>{guest.human.handle}</Link>{" "}
              <a
                href="#"
                onClick={(e) => {
                  e.preventDefault()
                  if (confirm("Log out?")) {
                    localStorage.clear()
                    setGuestToken(null)
                    navigate("/")
                  }
                }}
              >
                Log out
              </a>
            </>
          )}
        </span>
      </Nav>

      <Router>
        <NotFound default />
        <Home path="/" guest={guest} />
        <RedeemMagicLink path="/knock-knock/:token" setToken={setGuestToken} />
        <About path="/about" />
        <AddShow path="/add-show" guest={guest} />
        <Show path="/shows/:showSlug" guest={guest} />
        <Profile path="/:handle" />
      </Router>

      <footer></footer>
    </Layout>
  )
}

export default App
