import { MyShowStatus, Show } from "../types"

export const displayMyShowStatus = (status: MyShowStatus): string => {
  return {
    might_watch: "Might watch",
    currently_watching: "Currently watching",
    stopped_watching: "Stopped watching",
    waiting_for_more: "Waiting for more",
    finished: "Finished",
  }[status]
}

export const myShowBadgeProgress = (
  status: MyShowStatus
): "incomplete" | "partiallyComplete" | "complete" => {
  switch (status) {
    case "might_watch":
      return "incomplete"
    case "currently_watching":
      return "partiallyComplete"
    case "stopped_watching":
      return "partiallyComplete"
    case "waiting_for_more":
      return "partiallyComplete"
    case "finished":
      return "complete"
  }
}

export const myShowBadgeStatus = (
  status: MyShowStatus
): "success" | "info" | "attention" | "critical" | "warning" | "new" => {
  switch (status) {
    case "might_watch":
      return "new"
    case "currently_watching":
      return "attention"
    case "stopped_watching":
      return "warning"
    case "waiting_for_more":
      return "warning"
    case "finished":
      return "success"
  }
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
