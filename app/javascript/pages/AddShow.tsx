import React, { useEffect, useState, FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import debounce from "lodash.debounce"
import { Link, Page, Card, TextField } from "@shopify/polaris"

import ImportNewShow from "./AddShow/ImportNewShow"
import GoHome from "../components/GoHome"
import { Guest, Show } from "../types"
import { setHeadTitle } from "../hooks"

interface NoSearchYet {
  shows: null
}

interface SearchResultsLoaded {
  shows: Show[]
}

type SearchResults = NoSearchYet | SearchResultsLoaded

interface Props extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

interface ListResultsProps {
  searchResults: SearchResults
  token: string
  setLoading: (loadingState: boolean) => void
}

const ListResults = ({ searchResults, token, setLoading }: ListResultsProps) => {
  // Haven't searched yet
  if (!searchResults.shows) {
    return (
      <Card.Section>
        <p>Try searching for a show to add.</p>
      </Card.Section>
    )
  }

  // No results
  if (!searchResults.shows.length) {
    return (
      <Card.Section>
        <p>Not found!</p>
        <p>
          Seasoning is very new. I&rsquo;m sorry to be the one to tell you, but you&rsquo;re an
          early adopter. As such, I&rsquo;m relying on you to help populate our database with
          interesting shows, which will benefit everyone.
        </p>
        <ImportNewShow token={token} globalSetLoading={setLoading} />
      </Card.Section>
    )
  }

  return (
    <Card.Section>
      {searchResults.shows.length === 1 ? (
        <p>We have a match!</p>
      ) : (
        <p>There are {searchResults.shows.length} matching shows:</p>
      )}
      <ul>
        {searchResults.shows.map((show) => {
          return (
            <li key={show.id}>
              <Link url={`/shows/${show.slug}`}>{show.title}</Link>{" "}
            </li>
          )
        })}
      </ul>
    </Card.Section>
  )
}

const searchForShows = (
  title: string,
  token: string,
  setLoading: (loadingState: boolean) => void,
  callback: (shows: Show[]) => void
) => {
  setLoading(true)

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

const AddShow: FunctionComponent<Props> = ({ guest, setLoading }: Props) => {
  if (!guest || !guest.authenticated) {
    return <GoHome />
  }

  setHeadTitle("Add show")

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
    debouncedSearch(title, token, setLoading, (shows) => {
      setSearchResults({ shows: shows })
    })
  }, [title])

  return (
    <Page>
      <Card title="Add show">
        <TextField
          label="Search"
          type="text"
          value={title}
          onChange={setTitle}
          placeholder="Search for show"
          clearButton
          onClearButtonClick={() => setTitle("")}
        />

        <ListResults searchResults={searchResults} token={token} setLoading={setLoading} />
      </Card>
    </Page>
  )
}

export default AddShow
