import React, { FunctionComponent, useState, useEffect } from "react"
import { Checkbox } from "@shopify/polaris"

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
    <Checkbox
      label={"I've watched this season"}
      labelHidden={labelHidden}
      checked={hasWatched}
      onChange={async (value) => {
        setLoading(true)
        setUpdating(true)
        const response = await updateMySeason(season, guest.token, {
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
  )
}
