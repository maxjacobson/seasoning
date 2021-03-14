import React, { useEffect, useState } from "react"
import { Link } from "@reach/router"

import { Human, Show, YourShow } from "../../types"
import Loader from "../../components/Loader"

interface YourShows {
  your_shows: YourShow[]
}
interface Props {
  human: Human
  token: string
}

const ListShows = ({ shows }: { shows: YourShow[] }) => {
  if (shows.length) {
    return (
      <ul>
        {shows.map((yourShow) => {
          return (
            <li key={yourShow.show.id}>
              <Link to={`/shows/${yourShow.show.slug}`}>
                {yourShow.show.title}
              </Link>
            </li>
          )
        })}
      </ul>
    )
  } else {
    return <p>No shows yet!</p>
  }
}

const YourShows = (props: Props) => {
  const [loading, setLoading] = useState(true)
  const [shows, setShows] = useState<YourShow[]>([])

  useEffect(() => {
    fetch("/api/your-shows.json", {
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
        setLoading(false)
        setShows(data.your_shows)
      })
  }, [])

  return (
    <>
      <h2>{props.human.handle}'s shows</h2>
      {loading ? (
        <Loader />
      ) : (
        <>
          <ListShows shows={shows} />
          <Link to="/add-show">Add show</Link>
        </>
      )}
    </>
  )
}

export default YourShows
