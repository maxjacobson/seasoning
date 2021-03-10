import React from "react"
import { Link, Router } from "@reach/router"
import Home from "./pages/Home"
import Dashboard from "./pages/Dashboard"

const App = () => (
  <>
    <nav>
      <Link to="/">Home</Link> <Link to="dashboard">Dashboard</Link>
    </nav>
    <h1>Hello world</h1>

    <Router>
      <Home path="/" />
      <Dashboard path="/dashboard" />
    </Router>
  </>
)

export default App
