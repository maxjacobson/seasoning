import React from "react"
import { RouteComponentProps } from "@reach/router"

import { Guest } from "../types"

interface HomeProps extends RouteComponentProps {
  guest?: Guest
}

const Home = (props: HomeProps) => {
  const { guest } = props

  if (!guest) {
    return <p>Loading...</p>
  }

  if (guest.authenticated) {
    return <p>Welcome home, {guest.human.handle}</p>
  } else {
    return <p>Welcome -- sign up?</p>
  }
}
export default Home
