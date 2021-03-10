import React from "react"
import { RouteComponentProps } from "@reach/router"
import Loader from "../components/Loader"
import GetStarted from "./Home/GetStarted"
import YourShows from "./Home/YourShows"

import { Guest } from "../types"

interface HomeProps extends RouteComponentProps {
  guest?: Guest
}

const Home = (props: HomeProps) => {
  const { guest } = props

  if (!guest) {
    return <Loader />
  }

  if (guest.authenticated) {
    return (
      <>
        <h1>Welcome to Oiva</h1>
        <YourShows human={guest.human} token={guest.token} />
      </>
    )
  } else {
    return (
      <>
        <h1>Welcome to Oiva</h1>
        <GetStarted />
      </>
    )
  }
}
export default Home
