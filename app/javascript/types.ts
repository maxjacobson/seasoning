export interface HumanSettings {
  share_currently_watching: boolean
  default_review_visibility: Visibility
}

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
  poster_url: string | null
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
  | "next_up"
  | "currently_watching"
  | "stopped_watching"
  | "waiting_for_more"
  | "finished"

export type Visibility = "anybody" | "mutuals" | "myself"

export interface YourRelationshipToShow {
  added_at: string
  note_to_self: string | undefined
  status: MyShowStatus
}

export interface YourShow {
  show: Show
  your_relationship?: YourRelationshipToShow
}

interface YourRelationshipToProfile {
  self: boolean
  you_follow_them: boolean
  they_follow_you: boolean
}

export interface Profile {
  handle: string
  created_at: string
  currently_watching?: Show[]
  your_relationship?: YourRelationshipToProfile
}

export type Rating = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10
export interface SeasonReview {
  body: string
  visibility: boolean
  created_at: string
  updated_at: string
  rating: Rating | undefined
  author: Human
  season: Season
  viewing: number
  id: number
}

export interface YourRelationshipToSeason {
  watched: boolean
}

export interface YourSeason {
  show: Show
  season: Season
  your_relationship?: YourRelationshipToSeason
  your_reviews?: SeasonReview[]
}

export interface Import {
  id: number
  name: string
  poster_url: string | null
}
