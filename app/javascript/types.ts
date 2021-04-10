export interface Human {
  handle: string
  gravatar_url: string
}

export interface AuthenticatedGuest {
  authenticated: true
  human: Human
  token: string
}

export interface AnonymousGuest {
  authenticated: false
}

export type Guest = AuthenticatedGuest | AnonymousGuest

export interface Season {
  id: number
  name: string
  season_number: number
  episode_count: number
  slug: string
}
export interface Show {
  id: number
  title: string
  slug: string
  poster_url: string | null
  seasons: Season[]
}

export type MyShowStatus =
  | "might_watch"
  | "currently_watching"
  | "stopped_watching"
  | "waiting_for_more"
  | "finished"

export interface YourRelationshipToShow {
  added_at: string
  note_to_self: string | undefined
  status: MyShowStatus
}

export interface YourShow {
  show: Show
  your_relationship?: YourRelationshipToShow
}

export interface Profile {
  handle: string
  created_at: string
  currently_watching?: Show[]
}

export interface YourRelationshipToSeason {
  watched: boolean
}

export interface YourSeason {
  show: Show
  season: Season
  your_relationship?: YourRelationshipToSeason
}

export interface HumanSettings {
  share_currently_watching: boolean
}
