import React, { FunctionComponent, useContext, useEffect, useState } from "react"
import { Link, useNavigate, useParams } from "react-router-dom"
import { SetLoadingContext } from "../contexts"

import { Guest } from "../types"

interface Props {
  setGuest: (guest: Guest) => void
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

interface LoadingMagicLink {
  loading: true
}
interface ValidMagicLink {
  loading: false
  email: string
}
interface MagicLinkNotFound {
  loading: false
  email: null
}

type MagicLinkInfo = LoadingMagicLink | ValidMagicLink | MagicLinkNotFound

export const RedeemMagicLinkPage: FunctionComponent<Props> = ({ setGuest }: Props) => {
  const [magicLinkInfo, setMagicLinkInfo] = useState<MagicLinkInfo>({ loading: true })
  const [handle, setHandle] = useState<string>("")
  const [creating, setCreating] = useState(false)
  const navigate = useNavigate()
  const { token } = useParams()
  const setLoading = useContext(SetLoadingContext)

  useEffect(() => {
    setLoading(true)
    ;(async () => {
      const response = await fetch(`/api/magic-links/${token}.json`, {
        headers: {
          "Content-Type": "application/json",
        },
      })

      setLoading(false)

      if (response.status === 404) {
        setMagicLinkInfo({ loading: false, email: null })
      } else if (!response.ok) {
        throw new Error("Could not redeem magic link")
      } else {
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
          setMagicLinkInfo({ loading: false, email: data.email })
        }
      }
    })()
  }, [])

  if (magicLinkInfo.loading) {
    return <div>Checking your magic link....</div>
  }

  if (magicLinkInfo.email) {
    return (
      <div>
        <div>
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
        </div>
      </div>
    )
  } else {
    return (
      <div>
        <p>Hmmm, that magic does not seem to be valid.</p>
        <p>Perhaps it has expired.</p>
        <p>
          <Link to="/">Try again?</Link>
        </p>
      </div>
    )
  }
}
