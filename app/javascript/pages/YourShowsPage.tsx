import React, { FunctionComponent } from "react"
import { RouteComponentProps, Link } from "@reach/router"
import { YourShowsList } from "../components/YourShowsList"

import { Guest } from "../types"

interface Props extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

export const YourShowsPage: FunctionComponent<Props> = (props: Props) => {
  const { guest, setLoading } = props

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
