import { AuthenticatedGuest, Show } from "../types"
import { FunctionComponent, useContext, useEffect } from "react"
import { Button } from "./Button"
import debounce from "lodash.debounce"
import { SetLoadingContext } from "../contexts"
import { TextField } from "./TextField"
import { useNavigate } from "react-router-dom"

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
  callback: (results: Show[] | null) => void
  query: string
  setQuery: (query: string) => void
}

export const ShowSearchBar: FunctionComponent<Props> = ({ guest, callback, query, setQuery }) => {
  const navigate = useNavigate()
  const setLoading = useContext(SetLoadingContext)
  useEffect(() => {
    debouncedSearch(query, guest.token, setLoading, callback)
  }, [query])

  return (
    <form
      onSubmit={(event) => {
        event.preventDefault()
        navigate(`/search?q=${encodeURIComponent(query)}`)
      }}
    >
      <span className="mr-2">
        <TextField
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder="Search"
        />
      </span>
      <Button type="submit" value="Search" />
    </form>
  )
}
