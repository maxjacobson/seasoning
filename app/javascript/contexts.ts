import React from "react"

import { Guest } from "./types"

export const GuestContext = React.createContext<Guest>({ authenticated: false })
export const SetLoadingContext = React.createContext((_: boolean) => {
  // no-op
})
