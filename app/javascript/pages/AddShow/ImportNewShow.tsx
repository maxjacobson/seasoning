import React, { useState, FunctionComponent } from "react"
import { RouteComponentProps, navigate } from "@reach/router"
import styled from "styled-components"

import { Show } from "../../types"

const FullWidthSingleInputForm = styled.form`
  display: flex;
  input[type="text"] {
    flex-grow: 3;
  }
`

const ErrorMessage = styled.p`
  color: red;
`

interface Props extends RouteComponentProps {
  token: string
}

const ImportNewShow: FunctionComponent<Props> = ({ token }: Props) => {
  const [url, setURL] = useState("")
  const [loading, setLoading] = useState(false)
  const [errorMessage, setErrorMessage] = useState<string | null>(null)

  return (
    <>
      <p>Enter the URL of the show&rsquo;s English Wikipedia page:</p>
      <FullWidthSingleInputForm
        onSubmit={async (e) => {
          e.preventDefault()
          setLoading(true)

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

          if (response.ok) {
            const data: { show: Show } = await response.json()
            navigate(`/shows/${data.show.slug}`)
          } else {
            const data: { error: { message: string } } = await response.json()
            setLoading(false)
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
      </FullWidthSingleInputForm>
      {errorMessage && <ErrorMessage>Problems: {errorMessage}</ErrorMessage>}
    </>
  )
}

export default ImportNewShow
