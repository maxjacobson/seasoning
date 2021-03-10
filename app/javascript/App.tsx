import React, { useState, useEffect } from "react"
import { Link, Router, RouteComponentProps } from "@reach/router"
import { AnonymousGuest, AuthenticatedGuest, Guest } from "./types"
import NotFound from "./pages/NotFound"
import Home from "./pages/Home"
import RedeemMagicLink from "./pages/RedeemMagicLink"

const App = () => {
  const guestToken = localStorage.getItem("oiva-guest-token")
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
    <>
      <nav>
        <Link to="/">Home</Link>
      </nav>

      <Router>
        <NotFound default />
        <Home path="/" guest={guest} />
        <RedeemMagicLink path="/knock-knock/:token" setGuest={setGuest} />
      </Router>
    </>
  )
}

export default App
