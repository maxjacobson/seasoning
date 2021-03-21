import React, { useState, FunctionComponent } from "react"
import { RouteComponentProps, navigate } from "@reach/router"

import { Show } from "../../types"

interface Props extends RouteComponentProps {
  token: string
  globalSetLoading: (loadingState: boolean) => void
}

const ImportNewShow: FunctionComponent<Props> = ({ token, globalSetLoading }: Props) => {
  const [url, setURL] = useState("")
  const [loading, setLoading] = useState(false)
  const [errorMessage, setErrorMessage] = useState<string | null>(null)

  return (
    <>
      <p>Enter the URL of the show&rsquo;s English Wikipedia page:</p>
      <form
        onSubmit={async (e) => {
          e.preventDefault()
          setLoading(true)
          globalSetLoading(true)

          const response = await fetch("/api/shows.json", {
            body: JSON.stringify({
              shows: {
                wikipedia_url: url,
              },
            }),
            method: "POST",
            headers: {
              "X-SEASONING-TOKEN": token,
              "Content-Type": "application/json",
            },
          })

          setLoading(false)
          globalSetLoading(false)

          if (response.ok) {
            const data: { show: Show } = await response.json()
            navigate(`/shows/${data.show.slug}`)
          } else {
            const data: { error: { message: string } } = await response.json()
            setErrorMessage(data.error.message)
          }
        }}
      >
        <input
          type="text"
          placeholder="Wikipedia URL"
          value={url}
          onChange={(e) => setURL(e.target.value)}
          disabled={loading}
        />
        <input type="submit" value="Go" disabled={loading} />
      </form>
      {errorMessage && <p>Problems: {errorMessage}</p>}
    </>
  )
}

export default ImportNewShow
