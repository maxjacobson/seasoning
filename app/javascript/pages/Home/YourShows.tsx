import React, { useEffect, useState, FunctionComponent } from "react"
import { Link, Page, Card, DataTable, EmptyState, Spinner, Badge } from "@shopify/polaris"

import ShowPoster from "../../components/ShowPoster"
import { Human, YourShow } from "../../types"
import { displayMyShowStatus, myShowBadgeProgress, myShowBadgeStatus } from "../../helpers/my_shows"
import Logo from "../../images/logo.svg"

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
      <DataTable
        columnContentTypes={["text", "text"]}
        headings={["Show", "Status"]}
        rows={shows.map((yourShow) => {
          return [
            <>
              <Link key={yourShow.show.id} url={`/shows/${yourShow.show.slug}`}>
                <div>
                  <ShowPoster show={yourShow.show} size="small" />
                </div>
                {yourShow.show.title}
              </Link>
            </>,
            yourShow.your_relationship?.status ? (
              <Badge
                progress={myShowBadgeProgress(yourShow.your_relationship.status)}
                status={myShowBadgeStatus(yourShow.your_relationship.status)}
              >
                {displayMyShowStatus(yourShow.your_relationship.status)}
              </Badge>
            ) : (
              <span>&mdash;</span>
            ),
          ]
        })}
      />
    )
  } else {
    return <EmptyState heading="No shows yet" image={Logo} />
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
        <Card.Section title="Your shows">
          {loading ? (
            <Spinner accessibilityLabel="Loading your shows" size="large" />
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
