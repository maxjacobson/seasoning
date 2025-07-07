import { Episode, HumanLimits, MyShowStatus, Season, Show } from "../types";

export const displayMyShowStatus = (status: MyShowStatus): string => {
  return {
    might_watch: "Might watch",
    next_up: "Next up",
    currently_watching: "Currently watching",
    stopped_watching: "Stopped watching",
    waiting_for_more: "Waiting for more",
    finished: "Finished",
  }[status];
};

export const displayMyShowStatusLimit = (
  status: MyShowStatus,
  limits: HumanLimits,
): string => {
  if (atLimit(status, limits)) {
    return "(at limit!)";
  } else {
    return "";
  }
};

export const atLimit = (status: MyShowStatus, limits: HumanLimits): boolean => {
  if (status === "currently_watching") {
    return !!(
      limits.currently_watching_limit.max &&
      limits.currently_watching_limit.current >=
        limits.currently_watching_limit.max
    );
  } else {
    return false;
  }
};

export const updateMyShow = (
  show: Show,
  body: Record<string, unknown>,
): Promise<Response> => {
  return fetch(`/api/your-shows/${show.slug}.json`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
    },
    credentials: "same-origin",
    body: JSON.stringify(body),
  });
};

export const updateMySeason = (
  season: Season,
  body: Record<string, unknown>,
): Promise<Response> => {
  return fetch(`/api/your-seasons/${season.id}.json`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
    },
    credentials: "same-origin",
    body: JSON.stringify(body),
  });
};

export const updateMyEpisode = (
  season: Season,
  episode: Episode,
  body: Record<string, unknown>,
): Promise<Response> => {
  return fetch(
    `/api/your-seasons/${season.id}/episodes/${episode.episode_number}.json`,
    {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
      },
      credentials: "same-origin",
      body: JSON.stringify(body),
    },
  );
};
