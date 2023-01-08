import { Episode, MyShowStatus, Season, Show } from "../types"

export const displayMyShowStatus = (status: MyShowStatus): string => {
  return {
    might_watch: "Might watch",
    next_up: "Next up",
    currently_watching: "Currently watching",
    stopped_watching: "Stopped watching",
    waiting_for_more: "Waiting for more",
    finished: "Finished",
  }[status]
}

export const updateMyShow = (
  show: Show,
  token: string,
  body: Record<string, unknown>
): Promise<Response> => {
  return fetch(`/api/your-shows/${show.slug}.json`, {
    method: "PATCH",
    headers: {
      "X-SEASONING-TOKEN": token,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  })
}

export const updateMySeason = (
  season: Season,
  token: string,
  body: Record<string, unknown>
): Promise<Response> => {
  return fetch(`/api/your-seasons/${season.id}.json`, {
    method: "PATCH",
    headers: {
      "X-SEASONING-TOKEN": token,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  })
}

export const updateMyEpisode = (
  season: Season,
  episode: Episode,
  token: string,
  body: Record<string, unknown>
): Promise<Response> => {
  return fetch(`/api/your-seasons/${season.id}/episodes/${episode.episode_number}.json`, {
    method: "PATCH",
    headers: {
      "X-SEASONING-TOKEN": token,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  })
}
