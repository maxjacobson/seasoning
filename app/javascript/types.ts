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

export interface Show {
  id: number
  title: string
  slug: string
  number_of_seasons: number
}

export interface YourRelationshipToShow {
  added_at: string
  note_to_self: string | undefined
}

export interface YourShow {
  show: Show
  your_relationship?: YourRelationshipToShow
}

export interface Profile {
  handle: string
  created_at: string
}
