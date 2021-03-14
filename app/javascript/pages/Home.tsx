import React, { FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import Loader from "../components/Loader"
import GetStarted from "./Home/GetStarted"
import YourShows from "./Home/YourShows"

import { Guest } from "../types"

interface HomeProps extends RouteComponentProps {
  guest: Guest
}

const Home: FunctionComponent<HomeProps> = (props: HomeProps) => {
  const { guest } = props

  if (!guest) {
    return <Loader />
  }

  if (guest.authenticated) {
    return (
      <>
        <YourShows human={guest.human} token={guest.token} />
      </>
    )
  } else {
    return (
      <>
        <GetStarted />
      </>
    )
  }
}
export default Home
