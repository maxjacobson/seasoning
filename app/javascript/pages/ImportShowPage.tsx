import React, { FunctionComponent, useContext, useEffect, useState } from "react"
import { useNavigate, useSearchParams } from "react-router-dom"
import { stringify } from "query-string"
import styled from "@emotion/styled"

import { Import, Show } from "../types"
import { GuestContext } from "../contexts"

const ImportContainer = styled.div`
  margin: 10px 0;
  border: 1px dotted blue;
  padding: 5px;
  border-radius: 5px;
`

interface Props {
  setLoading: (loadingState: boolean) => void
}

export const ImportShowPage: FunctionComponent<Props> = ({ setLoading }: Props) => {
  const [searchParams] = useSearchParams()
  const searchQuery = searchParams.get("q")
  const [showQuery, setShowQuery] = useState(searchQuery || "")
  const [searching, setSearching] = useState(false)
  const [importing, setImporting] = useState(false)
  const [results, setResults] = useState<Import[] | null>(null)
  const navigate = useNavigate()
  const guest = useContext(GuestContext)

  const search = async () => {
    if (!guest.authenticated) {
      return
    }

    setLoading(true)
    setSearching(true)

    const response = await fetch(`/api/imports.json?${stringify({ query: showQuery })}`, {
      headers: {
        "X-SEASONING-TOKEN": guest.token,
        "Content-Type": "application/json",
      },
    })

    setLoading(false)
    setSearching(false)

    if (response.ok) {
      const data: { shows: Import[] } = await response.json()
      setResults(data.shows)
    } else {
      throw new Error("failed to search")
    }
  }

  useEffect(() => {
    search()
  }, [searchQuery])

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

          await search()
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
        <button type="submit" disabled={searching}>
          Search
        </button>
      </form>

      {results && (
        <div>
          {results.map((result) => (
            <ImportContainer key={result.id}>
              {result.poster_url && <img src={result.poster_url} />}
              <div>
                {result.name} {result.year && `(${result.year})`}
              </div>
              <div>
                <button
                  disabled={importing}
                  onClick={async () => {
                    setLoading(true)
                    setImporting(true)

                    const response = await fetch(`/api/imports.json`, {
                      headers: {
                        "X-SEASONING-TOKEN": guest.token,
                        "Content-Type": "application/json",
                      },
                      method: "POST",
                      body: JSON.stringify({
                        imports: {
                          id: result.id,
                        },
                      }),
                    })

                    setLoading(false)
                    setImporting(false)

                    if (response.ok) {
                      const data: { show: Show } = await response.json()
                      navigate(`/shows/${data.show.slug}`)
                    } else {
                      throw new Error("could not import show")
                    }
                  }}
                >
                  Import
                </button>
              </div>
            </ImportContainer>
          ))}
        </div>
      )}
    </>
  )
}
