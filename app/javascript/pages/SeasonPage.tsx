import React, { FunctionComponent, useEffect, useState } from "react"
import { RouteComponentProps } from "@reach/router"
import {
  Page,
  Card,
  SkeletonPage,
  Layout,
  SkeletonBodyText,
  Checkbox,
  Link,
} from "@shopify/polaris"
import { DateTime } from "luxon"

import { setHeadTitle } from "../hooks"
import { Guest, YourSeason } from "../types"
import { updateMySeason } from "../helpers/my_shows"
import { NewSeasonReviewModal } from "../components/NewSeasonReviewModal"

interface LoadingSeason {
  loading: true
}

interface SeasonNotFound {
  loading: false
  yourSeason: null
}

interface SeasonFound {
  loading: false
  yourSeason: YourSeason
}

type SeasonData = LoadingSeason | SeasonNotFound | SeasonFound

interface Props extends RouteComponentProps {
  showSlug?: string
  seasonSlug?: string
  guest: Guest
  setLoading: (loadingState: boolean) => void
  setCurrentModal: (_: React.ReactNode) => void
}

export const SeasonPage: FunctionComponent<Props> = ({
  guest,
  showSlug,
  seasonSlug,
  setLoading,
  setCurrentModal,
}: Props) => {
  const [response, setResponse] = useState<SeasonData>({ loading: true })
  const [hasWatched, setHasWatched] = useState<undefined | boolean>(undefined)
  const [updating, setUpdating] = useState(false)

  useEffect(() => {
    if (!seasonSlug) {
      return
    }

    ;(async () => {
      let headers
      if (guest.authenticated) {
        headers = { "X-SEASONING_TOKEN": guest.token }
      } else {
        headers = {}
      }
      setLoading(true)
      const response = await fetch(`/api/shows/${showSlug}/seasons/${seasonSlug}.json`, {
        headers: headers,
      })
      setLoading(false)

      if (response.status === 404) {
        setResponse({ loading: false, yourSeason: null })
      } else if (response.ok) {
        const yourSeason: YourSeason = await response.json()
        setResponse({ loading: false, yourSeason: yourSeason })
        setHasWatched(yourSeason.your_relationship ? yourSeason.your_relationship.watched : false)
      } else {
        throw new Error("Could not load season")
      }
    })()
  }, [seasonSlug])

  let headTitle

  if (!response.loading && response.yourSeason) {
    headTitle = `${response.yourSeason.show.title} - ${response.yourSeason.season.name}`
  }

  setHeadTitle(headTitle, [response])

  if (response.loading) {
    return (
      <SkeletonPage>
        <Layout>
          <Layout.Section>
            <Card sectioned>
              <SkeletonBodyText />
            </Card>
          </Layout.Section>
        </Layout>
      </SkeletonPage>
    )
  }

  const { yourSeason } = response

  if (!yourSeason) {
    return (
      <Page title="Not found" breadcrumbs={[{ url: `/shows/${showSlug}` }]}>
        <Card sectioned>
          <Card.Section>
            <p>Season does not exist!</p>
          </Card.Section>
        </Card>
      </Page>
    )
  }

  return (
    <Page title={yourSeason.show.title} subtitle={yourSeason.season.name}>
      <Card sectioned>
        <Card.Section title="Season info">
          <span>Episode count: {yourSeason.season.episode_count}</span>
        </Card.Section>

        {guest.authenticated && (
          <>
            <Card.Section title="Seen it?">
              <Checkbox
                label={"I've watched this season"}
                checked={hasWatched}
                onChange={async (value) => {
                  setLoading(true)
                  setUpdating(true)
                  const response = await updateMySeason(yourSeason.season, guest.token, {
                    season: {
                      watched: value,
                    },
                  })

                  setLoading(false)
                  setUpdating(false)

                  if (response.ok) {
                    setHasWatched(value)
                  } else {
                    throw new Error("Could not toggle watched status")
                  }
                }}
                disabled={hasWatched === undefined || updating}
              />
            </Card.Section>
          </>
        )}
      </Card>

      {guest.authenticated && yourSeason.your_reviews && (
        <Card
          title="Your review"
          actions={[
            {
              content: "Add review",
              onAction: () => {
                setCurrentModal(
                  <NewSeasonReviewModal
                    guest={guest}
                    show={yourSeason.show}
                    season={yourSeason.season}
                    globalSetLoading={setLoading}
                    onClose={() => setCurrentModal(null)}
                  />
                )
              },
            },
          ]}
        >
          <Card.Section>
            {yourSeason.your_reviews.length ? (
              <ul>
                {yourSeason.your_reviews.map((review, i) => {
                  return (
                    <li key={i}>
                      <Link
                        url={`/${guest.human.handle}/shows/${yourSeason.show.slug}/${
                          yourSeason.season.slug
                        }${review.viewing === 1 ? "" : `/${review.viewing}`}`}
                      >
                        {DateTime.fromISO(review.created_at).toLocaleString()}
                      </Link>
                    </li>
                  )
                })}
              </ul>
            ) : (
              <p>None yet</p>
            )}
          </Card.Section>
        </Card>
      )}
    </Page>
  )
}
