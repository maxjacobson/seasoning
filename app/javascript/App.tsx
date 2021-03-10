import React, { useState, useEffect } from "react"
import { Link, Router } from "@reach/router"
import Home from "./pages/Home"
import Dashboard from "./pages/Dashboard"

const App = () => {
  const guestToken = localStorage.getItem("oiva-guest-token")
  const [guest, setGuest] = useState(null)

  useEffect(() => {
    if (!guestToken) {
      return
    }

    fetch("/api/guest.json")
      .then((response) => response.json())
      .then((data) => setGuest(data))
  }, [guestToken])

  console.log("guest", guest)

  return (
    <>
      <nav>
        <Link to="/">Home</Link> <Link to="dashboard">Dashboard</Link>
      </nav>
      <h1>Hello world</h1>

      <Router>
        <Home path="/" guest={guest} />
        <Dashboard path="/dashboard" guest={guest} />
      </Router>
    </>
  )
}

export default App
