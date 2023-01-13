import { AppWithRouter } from "../App"
import { Guest } from "../types"
import React from "react"
import { render } from "react-dom"
;(async () => {
  const guestToken = localStorage.getItem("seasoning-guest-token")
  let guest

  if (guestToken) {
    const response = await fetch("/api/guest.json", {
      headers: { "X-SEASONING-TOKEN": guestToken },
    })
    guest = await response.json()
  } else {
    guest = { authenticated: false }
  }

  render(
    React.createElement(
      AppWithRouter,
      {
        initialGuest: guest as Guest,
      },
      null
    ),
    document.getElementById("app")
  )
})()
