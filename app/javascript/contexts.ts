import { Guest } from "./types"
import React from "react"

export const GuestContext = React.createContext<Guest>({ authenticated: false })
export const SetLoadingContext = React.createContext((_: boolean) => {
  // no-op
})
