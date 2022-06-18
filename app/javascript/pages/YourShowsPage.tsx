import React, { FunctionComponent, useContext } from "react"
import { Link } from "react-router-dom"
import { YourShowsList } from "../components/YourShowsList"

import { GuestContext } from "../contexts"

interface Props {
  setLoading: (loadingState: boolean) => void
}

export const YourShowsPage: FunctionComponent<Props> = (props: Props) => {
  const { setLoading } = props
  const guest = useContext(GuestContext)

  return (
    <div>
      <h1>Your shows</h1>
      {guest.authenticated ? (
        <YourShowsList human={guest.human} token={guest.token} globalSetLoading={setLoading} />
      ) : (
        <div>
          <Link to="/">Go home</Link>
        </div>
      )}
    </div>
  )
}
