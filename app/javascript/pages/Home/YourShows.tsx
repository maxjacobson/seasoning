import React, { useEffect, useState } from "react"

import { Human, Show } from "../../types"
import Loader from "../../components/Loader"

interface YourShows {
  shows: Show[]
}
interface Props {
  human: Human
  token: string
}

interface ListShowsProps {
  shows: Show[]
}

const ListShows = ({ shows }: ListShowsProps) => {
  if (shows.length) {
    return (
      <ul>
        {shows.map((show) => {
          return <li key={show.id}>{show.title}</li>
        })}
      </ul>
    )
  } else {
    return <p>No shows yet!</p>
  }
}

const YourShows = (props: Props) => {
  const [loading, setLoading] = useState(true)
  const [shows, setShows] = useState<Show[]>([])

  useEffect(() => {
    fetch("/api/your-shows.json", {
      headers: {
        "X-OIVA-TOKEN": props.token,
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
        setShows(data.shows)
      })
  }, [])

  return (
    <>
      <h2>{props.human.handle}'s shows</h2>
      {loading ? <Loader /> : <ListShows shows={shows} />}
    </>
  )
}

export default YourShows
