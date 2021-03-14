import React, { FunctionComponent, useState } from "react"
import { Link, Router, navigate } from "@reach/router"
import styled, { createGlobalStyle } from "styled-components"

import { Guest } from "./types"
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

interface Props {
  initialGuest: Guest
}

const App: FunctionComponent<Props> = ({ initialGuest }: Props) => {
  const [guest, setGuest] = useState<Guest>(initialGuest)

  return (
    <Layout>
      <GlobalStyle />

      <Nav>
        <span>
          <Link to="/">Seasoning</Link> <Link to="/about">About</Link>
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
                    setGuest({ authenticated: false })
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
        <RedeemMagicLink path="/knock-knock/:token" setGuest={setGuest} />
        <About path="/about" />
        <AddShow path="/add-show" guest={guest} />
        <Show path="/shows/:showSlug" guest={guest} />
        <Profile path="/:handle" />
      </Router>
    </Layout>
  )
}

export default App
