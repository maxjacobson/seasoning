import React, { useContext, useEffect, useState } from "react"
import { Link, useParams } from "react-router-dom"
import { GuestContext, SetLoadingContext } from "../contexts"
import { setHeadTitle } from "../hooks"
import { Episode, Season, Show } from "../types"
import { AirDate } from "../components/AirDate"

interface LoadingEpisode {
  loading: true
}

interface EpisodeFound {
  loading: false
  episode: Episode
  show: Show
  season: Season
}

type EpisodeData = LoadingEpisode | EpisodeFound

export const EpisodePage = () => {
  const [response, setResponse] = useState<EpisodeData>({ loading: true })
  const setLoading = useContext(SetLoadingContext)
  const { showSlug, seasonSlug, episodeNumber } = useParams()
  const guest = useContext(GuestContext)

  useEffect(() => {
    if (showSlug === undefined || seasonSlug === undefined || episodeNumber === undefined) {
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
      const response = await fetch(
        `/api/shows/${showSlug}/seasons/${seasonSlug}/episodes/${episodeNumber}.json`,
        {
          headers: headers,
        }
      )
      setLoading(false)

      if (response.ok) {
        const { episode, show, season } = await response.json()

        setResponse({
          loading: false,
          episode: episode,
          show: show,
          season: season,
        })
      } else {
        throw new Error("Could not load episode")
      }
    })()
  }, [showSlug, seasonSlug, episodeNumber])

  // TODO: this should be different
  setHeadTitle("episode title", [])

  let headTitle

  if (!response.loading) {
    headTitle = `${response.show.title}  - ${response.episode.name}`
  }

  setHeadTitle(headTitle, [response])

  if (response.loading) {
    return <p>Loading...</p>
  }

  const { show, episode, season } = response

  return (
    <>
      <h1>{episode.name}</h1>
      <p>
        An episode of <Link to={`/shows/${show.slug}`}>{show.title}</Link>,{" "}
        <Link to={`/shows/${show.slug}/${season.slug}`}>{season.name}</Link>.
      </p>

      <div>{episode.still_url && <img src={episode.still_url} />}</div>

      <div>
        Air date: <AirDate date={episode.air_date} />
      </div>
    </>
  )
}
