export interface AuthenticatedGuest {
  authenticated: true
  name: string
  token: string
}

export interface AnonymousGuest {
  authenticated: false
}

export type Guest = AuthenticatedGuest | AnonymousGuest
