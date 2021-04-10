import React, { useEffect, useState, FunctionComponent } from "react"
import {
  Link,
  Page,
  Card,
  DataTable,
  EmptyState,
  Spinner,
  Badge,
  Filters,
  ChoiceList,
  AppliedFilterInterface,
} from "@shopify/polaris"
import querystring from "query-string"

import ShowPoster from "../../components/ShowPoster"
import { Human, YourShow, MyShowStatus } from "../../types"
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
  const [queryValue, setQueryValue] = useState("")
  const [selectedStatuses, setSelectedStatuses] = useState<string[]>(["currently_watching"])
  const appliedFilters: AppliedFilterInterface[] = []

  if (selectedStatuses.length) {
    appliedFilters.push({
      key: "status",
      onRemove: () => setSelectedStatuses([]),
      label: `Status: ${selectedStatuses
        .map((status) => displayMyShowStatus(status as MyShowStatus))
        .join(", ")}`,
    })
  }

  useEffect(() => {
    props.globalSetLoading(true)

    const params: Record<string, unknown> = {}

    if (queryValue) {
      params.q = queryValue
    }

    if (selectedStatuses.length) {
      params.statuses = selectedStatuses
    }

    // TODO: debounce me
    fetch(`/api/your-shows.json?${querystring.stringify(params, { arrayFormat: "bracket" })}`, {
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
    <Page>
      <Card sectioned>
        <Card.Section title="Your shows">
          {loading ? (
            <Spinner accessibilityLabel="Loading your shows" size="large" />
          ) : (
            <>
              <Filters
                queryPlaceholder="Filter your shows"
                queryValue={queryValue}
                filters={[
                  {
                    key: "status",
                    label: "Status",
                    filter: (
                      <ChoiceList
                        title="Status"
                        titleHidden
                        choices={[
                          { label: "Might watch", value: "might_watch" },
                          { label: "Currently watching", value: "currently_watching" },
                          { label: "Stopped watching", value: "stopped_watching" },
                          { label: "Waiting for more", value: "waiting_for_more" },
                          { label: "Finished", value: "finished" },
                        ]}
                        selected={selectedStatuses}
                        onChange={setSelectedStatuses}
                        allowMultiple
                      />
                    ),
                    shortcut: true,
                  },
                ]}
                appliedFilters={appliedFilters}
                onQueryChange={setQueryValue}
                onQueryClear={() => {
                  setQueryValue("")
                }}
                onClearAll={() => {
                  setQueryValue("")
                }}
              />
              <ListShows shows={shows} />
            </>
          )}
        </Card.Section>
      </Card>
    </Page>
  )
}

export default YourShows
