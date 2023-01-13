import React, { useContext } from "react"
import { GuestContext } from "../contexts"
import { Link } from "react-router-dom"
import { YourShowsList } from "../components/YourShowsList"

export const YourShowsPage = () => {
  const guest = useContext(GuestContext)

  return (
    <div>
      <h1>Your shows</h1>
      {guest.authenticated ? (
        <YourShowsList human={guest.human} token={guest.token} />
      ) : (
        <div>
          <Link to="/">Go home</Link>
        </div>
      )}
    </div>
  )
}
