import React, { useEffect, useState, FunctionComponent } from "react"
import { Link } from "@reach/router"
import { stringify } from "query-string"

import { Poster } from "./Poster"
import { Human, YourShow } from "../types"
import { displayMyShowStatus } from "../helpers/my_shows"

interface YourShows {
  your_shows: YourShow[]
}
interface Props {
  human: Human
  token: string
  globalSetLoading: (loadingState: boolean) => void
}

interface ListShowProps {
  shows: YourShow[]
}
const ListShows = ({ shows }: ListShowProps) => {
  if (shows.length) {
    return (
      <table>
        <thead>
          <tr>
            <th>Show</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {shows.map((yourShow) => {
            return (
              <tr key={yourShow.show.id}>
                <td>
                  <Link key={yourShow.show.id} to={`/shows/${yourShow.show.slug}`}>
                    <div>
                      <Poster show={yourShow.show} size="small" url={yourShow.show.poster_url} />
                    </div>
                    {yourShow.show.title}
                  </Link>
                </td>

                <td>
                  {yourShow.your_relationship?.status ? (
                    <span>{displayMyShowStatus(yourShow.your_relationship.status)}</span>
                  ) : (
                    <span>&mdash;</span>
                  )}
                </td>
              </tr>
            )
          })}
        </tbody>
      </table>
    )
  } else {
    return <div>No shows yet. Maybe add some via the search at the top of the page?</div>
  }
}

export const YourShowsList: FunctionComponent<Props> = (props: Props) => {
  const [loading, setLoading] = useState(true)
  const [shows, setShows] = useState<YourShow[]>([])
  const [queryValue, setQueryValue] = useState("")
  const [selectedStatuses, setSelectedStatuses] = useState<string[]>(["currently_watching"])

  useEffect(() => {
    props.globalSetLoading(true)
    setLoading(true)

    const params: Record<string, unknown> = {}

    if (queryValue) {
      params.q = queryValue
    }

    if (selectedStatuses.length) {
      params.statuses = selectedStatuses
    }

    // TODO: debounce me
    fetch(`/api/your-shows.json?${stringify(params, { arrayFormat: "bracket" })}`, {
      headers: {
        "X-SEASONING-TOKEN": props.token,
      },
    })
      .then((response) => {
        props.globalSetLoading(false)
        setLoading(false)

        if (response.ok) {
          return response.json()
        } else {
          throw new Error("Could not fetch your shows")
        }
      })
      .then((data: YourShows) => {
        setShows(data.your_shows)
      })
  }, [queryValue, selectedStatuses])

  return (
    <div>
      <>
        <div>
          <input
            type="text"
            placeholder="Filter your shows"
            value={queryValue}
            onChange={(event) => setQueryValue(event.target.value)}
          />
        </div>
        <select
          multiple={true}
          value={selectedStatuses}
          onChange={(event) => {
            const statuses = Array.from(event.target.selectedOptions, (option) => option.value)

            setSelectedStatuses(statuses)
          }}
        >
          <option value="might_watch">Might watch</option>
          <option value="next_up">Next up</option>
          <option value="currently_watching">Currently watching</option>
          <option value="stopped_watching">Stopped watching</option>
          <option value="waiting_for_more">Waiting for more</option>
          <option value="finished">Finished</option>
        </select>
        {loading ? <div>Loading your shows...</div> : <ListShows shows={shows} />}
      </>
    </div>
  )
}
