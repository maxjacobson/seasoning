import React, { useEffect, useState } from "react"
import { Link, RouteComponentProps } from "@reach/router"
import debounce from "lodash.debounce"

import GoHome from "../components/GoHome"
import { Guest, Show } from "../types"

interface NoSearchYet {
  shows: null
}

interface SearchResultsLoaded {
  shows: Show[]
}

type SearchResults = NoSearchYet | SearchResultsLoaded

interface Props extends RouteComponentProps {
  guest?: Guest
}

interface ListResultsProps {
  searchResults: SearchResults
}

const ListResults = ({ searchResults }: ListResultsProps) => {
  // Haven't searched yet
  if (!searchResults.shows) {
    return (
      <>
        <p>Try searching for a show to add.</p>
      </>
    )
  }

  // No results
  if (!searchResults.shows.length) {
    return <p>Huh... I don't know that show. Sorry.</p>
  }

  return (
    <>
      <p>Those are {searchResults.shows.length} shows</p>
      <ul>
        {searchResults.shows.map((show) => {
          return (
            <li key={show.id}>
              <Link to={`/shows/${show.slug}`}>{show.title}</Link>
            </li>
          )
        })}
      </ul>
    </>
  )
}

const searchForShows = (
  title: string,
  token: string,
  callback: (shows: Show[]) => void
) => {
  fetch(`/api/shows.json?q=${encodeURIComponent(title)}`, {
    headers: {
      "X-SEASONING-TOKEN": token,
    },
  })
    .then((response) => {
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

const AddShow = ({ guest }: Props) => {
  if (!guest || !guest.authenticated) {
    return <GoHome />
  }

  const { token } = guest
  const [title, setTitle] = useState("")
  const [searchResults, setSearchResults] = useState<SearchResults>({
    shows: null,
  })

  useEffect(() => {
    if (!title) {
      setSearchResults({ shows: null })
      return
    }
    debouncedSearch(title, token, (shows) => {
      setSearchResults({ shows: shows })
    })
  }, [title])

  return (
    <>
      <h2>Add show</h2>

      <input
        type="text"
        value={title}
        onChange={(e) => {
          setTitle(e.target.value)
        }}
        placeholder="Search for show"
      />

      <ListResults searchResults={searchResults} />
    </>
  )
}

export default AddShow
