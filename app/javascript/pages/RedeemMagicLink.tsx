import React, { useState, useEffect } from "react"
import { RouteComponentProps, navigate } from "@reach/router"
import { Guest, AuthenticatedGuest } from "../types"
import { csrfToken } from "../networking/csrf"

interface Props extends RouteComponentProps {
  setToken: (token: string) => void
  token?: string
}

interface AlreadyExists {
  already_exists: true
  email: string
  handle: string
  session_token: string
}

interface NewHuman {
  already_exists: false
  email: string
}

type Redemption = AlreadyExists | NewHuman

const RedeemMagicLink = (props: Props) => {
  const { token } = props
  const [email, setEmail] = useState<string | null>(null)
  const [handle, setHandle] = useState<string>("")
  const [creating, setCreating] = useState(false)

  useEffect(() => {
    fetch(`/api/magic-links/${token}.json`, {
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => {
        if (response.ok) {
          return response.json()
        } else {
          throw new Error("Could not redeem magic link")
        }
      })
      .then((data: Redemption) => {
        if (data.already_exists) {
          localStorage.setItem("oiva-guest-token", data.session_token)
          props.setToken(data.session_token)
          navigate("/")
        } else {
          setEmail(data.email)
        }
      })
  }, [])

  if (email) {
    return (
      <>
        <p>Thanks for clicking the link.</p>
        <p>Just one more question... What do you want to be called?</p>

        <form
          onSubmit={(e) => {
            e.preventDefault()

            setCreating(true)

            fetch("/api/humans.json", {
              body: JSON.stringify({
                humans: {
                  magic_link_token: token,
                  handle: handle,
                },
              }),
              method: "POST",
              headers: {
                "X-CSRF-Token": csrfToken(),
                "Content-Type": "application/json",
              },
            })
              .then((response) => {
                if (response.ok) {
                  return response.json()
                } else {
                  throw new Error("Could not create human")
                }
              })
              .then((data: AlreadyExists) => {
                localStorage.setItem("oiva-guest-token", data.session_token)
                props.setToken(data.session_token)
                navigate("/")
              })
          }}
        >
          <input
            type="text"
            value={handle}
            placeholder="Your handle"
            onChange={(e) => setHandle(e.target.value)}
          />
          <input type="submit" value="Go" disabled={creating} />
        </form>
      </>
    )
  } else {
    return <p>Checking your link...</p>
  }
}

export default RedeemMagicLink
