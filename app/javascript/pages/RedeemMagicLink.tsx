import React, { useState, useEffect, FunctionComponent } from "react"
import { RouteComponentProps, navigate } from "@reach/router"
import { Page, Card } from "@shopify/polaris"

import { Guest } from "../types"

interface Props extends RouteComponentProps {
  token?: string
  setGuest: (guest: Guest) => void
  setLoading: (loadingState: boolean) => void
}

interface AlreadyExists {
  already_exists: true
  email: string
  handle: string
  session_token: string
  gravatar_url: string
}

interface NewHuman {
  already_exists: false
  email: string
}

type Redemption = AlreadyExists | NewHuman

const RedeemMagicLink: FunctionComponent<Props> = ({ token, setGuest, setLoading }: Props) => {
  const [email, setEmail] = useState<string | null>(null)
  const [handle, setHandle] = useState<string>("")
  const [creating, setCreating] = useState(false)

  useEffect(() => {
    setLoading(true)
    ;(async () => {
      const response = await fetch(`/api/magic-links/${token}.json`, {
        headers: {
          "Content-Type": "application/json",
        },
      })

      setLoading(false)

      if (!response.ok) {
        throw new Error("Could not redeem magic link")
      }

      const data: Redemption = await response.json()

      if (data.already_exists) {
        localStorage.setItem("seasoning-guest-token", data.session_token)
        setGuest({
          authenticated: true,
          human: { handle: data.handle, gravatar_url: data.gravatar_url },
          token: data.session_token,
        })
        navigate("/")
      } else {
        setEmail(data.email)
      }
    })()
  }, [])

  if (email) {
    return (
      <Page>
        <Card sectioned>
          <p>Thanks for clicking the link.</p>
          <p>Just one more question... What do you want to be called?</p>

          <form
            onSubmit={(e) => {
              e.preventDefault()

              setLoading(true)

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
                  "Content-Type": "application/json",
                },
              })
                .then((response) => {
                  setLoading(false)
                  if (response.ok) {
                    return response.json()
                  } else {
                    throw new Error("Could not create human")
                  }
                })
                .then((data: AlreadyExists) => {
                  localStorage.setItem("seasoning-guest-token", data.session_token)
                  setGuest({
                    authenticated: true,
                    human: { handle: data.handle, gravatar_url: data.gravatar_url },
                    token: data.session_token,
                  })
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
        </Card>
      </Page>
    )
  } else {
    return (
      <Page>
        <Card sectioned>
          <p>Checking your link...</p>
        </Card>
      </Page>
    )
  }
}

export default RedeemMagicLink
