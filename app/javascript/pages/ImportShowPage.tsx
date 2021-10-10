import React, { FunctionComponent, useState } from "react"
import { RouteComponentProps, navigate } from "@reach/router"

import { Guest, Show } from "../types"

interface Props extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

export const ImportShowPage: FunctionComponent<Props> = ({ setLoading, guest }: Props) => {
  const [showQuery, setShowQuery] = useState("")
  const [importing, setImporting] = useState(false)
  const [errorMessage, setErrorMessage] = useState<string | null>(null)

  if (!guest.authenticated) {
    return <div>Not found...</div>
  }

  return (
    <>
      <h1>Import show</h1>

      <p>
        Seasoning is very new. I&rsquo;m sorry to be the one to tell you, but you&rsquo;re an early
        adopter. As such, I&rsquo;m relying on you to help populate our database with interesting
        shows, which will benefit everyone.
      </p>

      <form
        onSubmit={async (event) => {
          event.preventDefault()

          setLoading(true)
          setImporting(true)

          const response = await fetch("/api/shows.json", {
            body: JSON.stringify({
              shows: {
                query: showQuery,
              },
            }),
            method: "POST",
            headers: {
              "X-SEASONING-TOKEN": guest.token,
              "Content-Type": "application/json",
            },
          })

          setLoading(false)
          setImporting(false)

          if (response.ok) {
            const data: { show: Show } = await response.json()
            navigate(`/shows/${data.show.slug}`)
          } else {
            const data: { error: { message: string } } = await response.json()
            setErrorMessage(data.error.message)
          }
        }}
      >
        <div>
          <label>Name of show</label>
        </div>
        <div>
          <input
            type="text"
            value={showQuery}
            onChange={(event) => setShowQuery(event.target.value)}
          />
        </div>
        <button type="submit" disabled={importing}>
          Import
        </button>
      </form>
      {errorMessage && <div>{errorMessage}</div>}
    </>
  )
}
