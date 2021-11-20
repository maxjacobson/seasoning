import React, { FunctionComponent } from "react"
import { Link } from "react-router-dom"

import { setHeadTitle } from "../hooks"
import { Show } from "../types"
interface Props {
  searchResults: Show[] | null
}

export const SearchResultsPage: FunctionComponent<Props> = ({ searchResults }) => {
  setHeadTitle("Search results")

  return (
    <>
      <h1>Search results</h1>
      {searchResults === null ? (
        <p>No results. Try searching something else.</p>
      ) : (
        <ul>
          {searchResults.map((show) => (
            <li key={show.id}>
              <Link to={`/shows/${show.slug}`}>{show.title}</Link>
            </li>
          ))}
        </ul>
      )}
      <p>
        Not seeing what you&rsquo;re looking for? You might be the first person to want to add it.
        Feel free to <Link to="/import-show">import it here</Link>.
      </p>
    </>
  )
}
