import React, { useState, useEffect } from "react"
import { RouteComponentProps } from "@reach/router"
import Loader from "../components/Loader"
import { csrfToken } from "../networking/csrf"

import { Guest } from "../types"

interface HomeProps extends RouteComponentProps {
  guest?: Guest
}

const GetStarted = () => {
  const [email, setEmail] = useState("")
  const [loading, setLoading] = useState(false)
  const [createdMagicLink, setCreatedMagicLink] = useState(false)

  useEffect(() => {
    if (!loading) {
      return
    }

    fetch("/api/magic-links.json", {
      headers: {
        "X-CSRF-Token": csrfToken(),
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ magic_link: { email: email } }),
      method: "POST",
    })
      .then((response) => {
        if (response.ok) {
          return response.json()
        } else {
          throw new Error("Could not create magic link")
        }
      })
      .then((data) => {
        setLoading(false)
        setCreatedMagicLink(true)
      })
  }, [loading])

  if (createdMagicLink) {
    return <p>Check your email!</p>
  } else {
    return (
      <div>
        <p>
          To sign up or log in, just enter your email address and we'll send you
          a link to get started:
        </p>
        <div>
          <form
            onSubmit={(e) => {
              e.preventDefault()
              setLoading(true)
            }}
          >
            <input
              type="text"
              placeholder="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              disabled={loading}
            />
            <input type="submit" value="Go" disabled={loading} />
          </form>
        </div>
      </div>
    )
  }
}

const Home = (props: HomeProps) => {
  const { guest } = props

  if (!guest) {
    return <Loader />
  }

  if (guest.authenticated) {
    return <p>Welcome home, {guest.human.handle}</p>
  } else {
    return (
      <>
        <h1>Welcome to Oiva</h1>
        <GetStarted />
      </>
    )
  }
}
export default Home
