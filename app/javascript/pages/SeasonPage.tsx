import React, { FunctionComponent, useEffect, useState } from "react"
import { RouteComponentProps, Link } from "@reach/router"
import { DateTime } from "luxon"

import { setHeadTitle } from "../hooks"
import { Guest, YourSeason } from "../types"
import { SeenSeasonCheckbox } from "../components/SeenSeasonCheckbox"
import { Poster } from "../components/Poster"

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
}

export const SeasonPage: FunctionComponent<Props> = ({
  guest,
  showSlug,
  seasonSlug,
  setLoading,
}: Props) => {
  const [response, setResponse] = useState<SeasonData>({ loading: true })

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
    return <div>Loading...</div>
  }

  const { yourSeason } = response

  if (!yourSeason) {
    return (
      <div>
        <h1>Not found</h1>
        <p>Season does not exist!</p>
        <p>
          <Link to={`/shows/${showSlug}`}>Back</Link>
        </p>
      </div>
    )
  }

  return (
    <div>
      <h1>{yourSeason.show.title}</h1>
      <h2>{yourSeason.season.name}</h2>
      <p>
        <Link to={`/shows/${showSlug}`}>Back</Link>
      </p>

      <div>
        <div>
          <Poster url={yourSeason.season.poster_url} size="large" show={yourSeason.show} />
        </div>
        <div>
          <h2>Season info</h2>
          <span>Episode count: {yourSeason.season.episode_count}</span>
        </div>

        {guest.authenticated && (
          <>
            <div>
              <h2>Seen it?</h2>
              <SeenSeasonCheckbox
                setLoading={setLoading}
                guest={guest}
                show={yourSeason.show}
                season={yourSeason.season}
              />
            </div>
          </>
        )}
      </div>

      {guest.authenticated && yourSeason.your_reviews && (
        <div>
          <h2>Your review</h2>
          <div>
            <Link to={`/shows/${yourSeason.show.slug}/${yourSeason.season.slug}/reviews/new`}>
              Add review
            </Link>
          </div>
          <div>
            {yourSeason.your_reviews.length ? (
              <ul>
                {yourSeason.your_reviews.map((review, i) => {
                  return (
                    <li key={i}>
                      <Link
                        to={`/${guest.human.handle}/shows/${yourSeason.show.slug}/${
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
          </div>
        </div>
      )}
    </div>
  )
}
