import React, { useState, useEffect } from "react"
import { Link, Router, RouteComponentProps } from "@reach/router"
import { AnonymousGuest, AuthenticatedGuest, Guest } from "./types"
import Home from "./pages/Home"
import Dashboard from "./pages/Dashboard"

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
        <Link to="/">Home</Link> <Link to="dashboard">Dashboard</Link>
      </nav>
      <h1>Hello world</h1>

      <Router>
        <Home path="/" guest={guest} />
        <Dashboard path="/dashboard" />
      </Router>
    </>
  )
}

export default App
