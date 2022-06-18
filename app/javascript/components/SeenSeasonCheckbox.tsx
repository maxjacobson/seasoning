import React, { FunctionComponent, useEffect, useState } from "react"

import { updateMySeason } from "../helpers/my_shows"
import { AuthenticatedGuest, Season, Show, YourSeason } from "../types"

interface Props {
  setLoading: (loadingState: boolean) => void
  guest: AuthenticatedGuest
  show: Show
  season: Season
  labelHidden?: boolean
}

export const SeenSeasonCheckbox: FunctionComponent<Props> = ({
  setLoading,
  guest,
  season,
  labelHidden,
  show,
}) => {
  const [updating, setUpdating] = useState(false)
  const [hasWatched, setHasWatched] = useState<boolean | undefined>(undefined)

  useEffect(() => {
    ;(async () => {
      setLoading(true)
      const response = await fetch(`/api/shows/${show.slug}/seasons/${season.slug}.json`, {
        headers: { "X-SEASONING_TOKEN": guest.token },
      })
      setLoading(false)

      if (response.ok) {
        const yourSeason: YourSeason = await response.json()
        setHasWatched(!!yourSeason.your_relationship?.watched)
      } else {
        throw new Error("Could not load season")
      }
    })()
  }, [])

  return (
    <>
      <input
        type="checkbox"
        name={season.slug}
        id={season.slug}
        checked={!!hasWatched}
        disabled={hasWatched === undefined || updating}
        onChange={async () => {
          setLoading(true)
          setUpdating(true)
          const response = await updateMySeason(season, guest.token, {
            season: {
              watched: !hasWatched,
            },
          })

          setLoading(false)
          setUpdating(false)

          if (response.ok) {
            setHasWatched(!hasWatched)
          } else {
            throw new Error("Could not toggle watched status")
          }
        }}
      />
      {!labelHidden && <label htmlFor={season.slug}>I&rsquo;ve watched this season</label>}
    </>
  )
}
