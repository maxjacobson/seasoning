import React, { useEffect, useState, FunctionComponent } from "react"
import { Link } from "@reach/router"
import styled from "styled-components"

import { Human, YourShow } from "../../types"
import Loader from "../../components/Loader"

const Gallery = styled.div`
  display: flex;
  margin-bottom: 25px;
  flex-wrap: wrap;
`

const GalleryItem = styled.div`
  height: 100px;
  border: 1px dotted black;
  width: 200px;
  margin: 5px;
  background-color: #ffe8f5;
  display: flex;
  flex-direction: column;
  justify-content: center;
`

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
      <Gallery>
        {shows.map((yourShow) => {
          return (
            <Link to={`/shows/${yourShow.show.slug}`} key={yourShow.show.id}>
              <GalleryItem>{yourShow.show.title}</GalleryItem>
            </Link>
          )
        })}
      </Gallery>
    )
  } else {
    return <p>No shows yet!</p>
  }
}

const YourShows: FunctionComponent<Props> = (props: Props) => {
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
      <h2>{props.human.handle}&rsquo;s shows</h2>
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
