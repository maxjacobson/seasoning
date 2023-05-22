import { FunctionComponent, useContext, useEffect, useState } from "react"
import { Human, YourShow } from "../types"
import { Link, useSearchParams } from "react-router-dom"
import { Button } from "./Button"
import { displayMyShowStatus } from "../helpers/my_shows"
import { Markdown } from "./Markdown"
import { Poster } from "./Poster"
import queryString from "query-string"
import { Select } from "./Select"
import { SetLoadingContext } from "../contexts"
import { TextField } from "./TextField"

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
      <div className="mx-0 my-2 flex flex-wrap gap-4">
        {shows.map((yourShow) => {
          return (
            <div
              key={yourShow.show.id}
              className="w-60 rounded-lg border-2 border-dashed border-yellow-500 p-2"
            >
              <div className="flex flex-col">
                <div className="self-center">
                  <Link key={yourShow.show.id} to={`/shows/${yourShow.show.slug}`}>
                    <div>
                      <Poster show={yourShow.show} size="large" url={yourShow.show.poster_url} />
                    </div>
                    {yourShow.show.title}
                  </Link>
                </div>

                <div className="self-center">
                  {yourShow.your_relationship?.status ? (
                    <span>{displayMyShowStatus(yourShow.your_relationship.status)}</span>
                  ) : (
                    <span>&mdash;</span>
                  )}
                </div>
              </div>

              {yourShow.your_relationship?.note_to_self ? (
                <div className=" mx-0 my-2.5  break-words border-t border-dotted border-slate-300	p-0.5">
                  <h2 className="text-lg font-bold">Note to self</h2>
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

  const page: number = parseInt(searchParams.get("page") || "") || 1

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

    params.page = page

    // TODO: debounce me
    fetch(`/api/your-shows.json?${queryString.stringify(params, { arrayFormat: "bracket" })}`, {
      headers: {
        "X-SEASONING-TOKEN": props.token,
      },
    })
      .then((response) => {
        if (response.ok) {
          return response.json()
        } else {
          throw new Error("Could not fetch your shows")
        }
      })
      .then((data: YourShows) => {
        setShows(data.your_shows)
        setLoading(false)
        globalSetLoading(false)
      })
  }, [titleQueryValue, statusesFilterValue.join("-"), page])

  return (
    <div>
      <>
        <div className="mb-2">
          <TextField
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
        <Select
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
        </Select>
        {loading ? <div>Loading your shows...</div> : <ListShows shows={shows} />}
        <div className="flex justify-between">
          <div>
            {page > 1 && (
              <Button
                onClick={() => {
                  searchParams.set("page", (page - 1).toString())
                  setSearchParams(searchParams)
                }}
              >
                Previous
              </Button>
            )}
          </div>
          <div className="font-bold">Page {page} </div>
          <div>
            <Button
              onClick={() => {
                searchParams.set("page", (page + 1).toString())
                setSearchParams(searchParams)
              }}
            >
              Next
            </Button>
          </div>
        </div>
      </>
    </div>
  )
}
