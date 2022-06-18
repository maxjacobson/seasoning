import React from "react"

import { Guest } from "./types"

export const GuestContext = React.createContext<Guest>({ authenticated: false })
