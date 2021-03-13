export interface Human {
  handle: string
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
