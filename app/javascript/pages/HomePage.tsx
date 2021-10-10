import React, { FunctionComponent } from "react"
import { navigate, RouteComponentProps } from "@reach/router"
import { GetStarted } from "../components/GetStarted"

import { Guest } from "../types"

interface HomeProps extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

export const HomePage: FunctionComponent<HomeProps> = (props: HomeProps) => {
  const { guest, setLoading } = props

  if (guest.authenticated) {
    navigate("/shows")

    return <div>Loading...</div>
  } else {
    return (
      <div>
        <h1>Welcome</h1>
        <h2>This is seasoning, a website about TV shows</h2>
        <GetStarted globalSetLoading={setLoading} />
      </div>
    )
  }
}
