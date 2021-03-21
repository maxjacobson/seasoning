import React, { useEffect, useState, FunctionComponent } from "react"
import { Link, Page, Card } from "@shopify/polaris"

import { Human, YourShow } from "../../types"

interface YourShows {
  your_shows: YourShow[]
}
interface Props {
  human: Human
  token: string
  globalSetLoading: (loadingState: boolean) => void
}

const ListShows = ({ shows }: { shows: YourShow[] }) => {
  if (shows.length) {
    return (
      <ul>
        {shows.map((yourShow) => {
          return (
            <li key={yourShow.show.id}>
              <Link url={`/shows/${yourShow.show.slug}`}>{yourShow.show.title}</Link>
            </li>
          )
        })}
      </ul>
    )
  } else {
    return <p>No shows yet!</p>
  }
}

const YourShows: FunctionComponent<Props> = (props: Props) => {
  const [loading, setLoading] = useState(true)
  const [shows, setShows] = useState<YourShow[]>([])

  useEffect(() => {
    props.globalSetLoading(true)

    fetch("/api/your-shows.json", {
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
  }, [])

  return (
    <Page>
      <Card sectioned>
        <Card.Section title={<>{props.human.handle}&rsquo;s shows</>}>
          {loading ? (
            <p>Loading...</p>
          ) : (
            <>
              <ListShows shows={shows} />
            </>
          )}
        </Card.Section>
      </Card>
    </Page>
  )
}

export default YourShows
