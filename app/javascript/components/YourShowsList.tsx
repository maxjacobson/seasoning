import { Human, YourShow } from "../types"
import { Link, useSearchParams } from "react-router-dom"
import React, { FunctionComponent, useContext, useEffect, useState } from "react"
import { displayMyShowStatus } from "../helpers/my_shows"
import { Markdown } from "./Markdown"
import { Poster } from "./Poster"
import queryString from "query-string"
import { SetLoadingContext } from "../contexts"

interface YourShows {
  your_shows: YourShow[]
}
interface Props {
  human: Human
  token: string
}

interface ListShowProps {
  shows: YourShow[]
}
const ListShows = ({ shows }: ListShowProps) => {
  if (shows.length) {
    return (
      <div className="my-2 mx-0">
        {shows.map((yourShow) => {
          return (
            <div key={yourShow.show.id}>
              <div>
                <Link key={yourShow.show.id} to={`/shows/${yourShow.show.slug}`}>
                  <div>
                    <Poster show={yourShow.show} size="small" url={yourShow.show.poster_url} />
                  </div>
                  {yourShow.show.title}
                </Link>
              </div>

              <div>
                {yourShow.your_relationship?.status ? (
                  <span>{displayMyShowStatus(yourShow.your_relationship.status)}</span>
                ) : (
                  <span>&mdash;</span>
                )}
              </div>

              {yourShow.your_relationship?.note_to_self ? (
                <div className="mx-0 my-2.5 border border-solid border-black p-0.5">
                  <h2>Note to self</h2>
                  <Markdown markdown={yourShow.your_relationship.note_to_self} />
                </div>
              ) : (
                <></>
              )}
            </div>
          )
        })}
      </div>
    )
  } else {
    return <div>No shows yet. Maybe add some via the search at the top of the page?</div>
  }
}

export const YourShowsList: FunctionComponent<Props> = (props: Props) => {
  const globalSetLoading = useContext(SetLoadingContext)
  const [loading, setLoading] = useState(true)
  const [shows, setShows] = useState<YourShow[]>([])
  const [searchParams, setSearchParams] = useSearchParams()

  const titleQueryValue = searchParams.get("title") || ""
  const statusesFilterValue = searchParams.getAll("statuses").length
    ? searchParams.getAll("statuses")
    : ["currently_watching"]

  useEffect(() => {
    globalSetLoading(true)
    setLoading(true)

    const params: Record<string, unknown> = {}

    if (titleQueryValue) {
      params.q = titleQueryValue
    }

    if (statusesFilterValue.length) {
      params.statuses = statusesFilterValue
    }

    // TODO: debounce me
    fetch(`/api/your-shows.json?${queryString.stringify(params, { arrayFormat: "bracket" })}`, {
      headers: {
        "X-SEASONING-TOKEN": props.token,
      },
    })
      .then((response) => {
        globalSetLoading(false)
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
  }, [titleQueryValue, statusesFilterValue.join("-")])

  return (
    <div>
      <>
        <div>
          <input
            type="text"
            placeholder="Filter your shows"
            value={titleQueryValue}
            onChange={(event) => {
              if (event.target.value) {
                searchParams.set("title", event.target.value)
              } else {
                searchParams.delete("title")
              }
              setSearchParams(searchParams)
            }}
          />
        </div>
        <select
          multiple={true}
          value={statusesFilterValue}
          onChange={(event) => {
            const statuses = Array.from(event.target.selectedOptions, (option) => option.value)

            setSearchParams({
              title: titleQueryValue,
              statuses: statuses,
            })
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
