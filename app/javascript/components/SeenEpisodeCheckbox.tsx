import React, { FunctionComponent, useContext, useState } from "react"
import { SetLoadingContext } from "../contexts"
import { updateMyEpisode } from "../helpers/my_shows"
import { AuthenticatedGuest, Episode, Season, YourRelationshipToSeason } from "../types"

type Props = {
  season: Season
  episode: Episode
  guest: AuthenticatedGuest
  yourRelationshipToSeason: YourRelationshipToSeason
}

export const SeenEpisodeCheckbox: FunctionComponent<Props> = ({
  guest,
  episode,
  season,
  yourRelationshipToSeason,
}) => {
  const [hasSeen, setHasSeen] = useState(
    yourRelationshipToSeason.watched_episode_numbers.includes(episode.episode_number)
  )
  const [updating, setUpdating] = useState(false)
  const setLoading = useContext(SetLoadingContext)

  return (
    <input
      type="checkbox"
      checked={hasSeen}
      disabled={updating}
      onChange={async () => {
        setLoading(true)
        setUpdating(true)

        const response = await updateMyEpisode(season, episode, guest.token, {
          seen: !hasSeen,
        })

        setLoading(false)
        setUpdating(false)

        if (response.ok) {
          setHasSeen(!hasSeen)
        } else {
          throw new Error("Could not toggle seen status")
        }
      }}
    />
  )
}
