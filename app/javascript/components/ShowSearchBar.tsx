import React, { FunctionComponent, useEffect } from "react"
import debounce from "lodash.debounce"

import { AuthenticatedGuest, Show } from "../types"
import { navigate } from "@reach/router"

const searchForShows = (
  title: string,
  token: string,
  setLoading: (loadingState: boolean) => void,
  callback: (shows: Show[] | null) => void
) => {
  setLoading(true)

  if (!title) {
    callback(null)
    setLoading(false)
    return
  }

  fetch(`/api/shows.json?q=${encodeURIComponent(title)}`, {
    headers: {
      "X-SEASONING-TOKEN": token,
    },
  })
    .then((response) => {
      setLoading(false)
      if (response.ok) {
        return response.json()
      } else {
        throw new Error("Could not search shows")
      }
    })
    .then((data) => {
      callback(data.shows)
    })
}
const debouncedSearch = debounce(searchForShows, 400, { trailing: true })

interface Props {
  guest: AuthenticatedGuest
  setLoading: (loading: boolean) => void
  callback: (results: Show[] | null) => void
  query: string
  setQuery: (query: string) => void
}

export const ShowSearchBar: FunctionComponent<Props> = ({
  guest,
  setLoading,
  callback,
  query,
  setQuery,
}) => {
  useEffect(() => {
    debouncedSearch(query, guest.token, setLoading, callback)
  }, [query])

  return (
    <form
      onSubmit={(event) => {
        event.preventDefault()
        navigate("/search")
      }}
    >
      <input
        type="text"
        value={query}
        onChange={(event) => setQuery(event.target.value)}
        placeholder="Search"
      />
      <input type="submit" value="Search" />
    </form>
  )
}
