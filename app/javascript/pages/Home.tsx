import React from "react"
import { RouteComponentProps } from "@reach/router"
import Loader from "../components/Loader"

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
    return <p>Welcome home, {guest.human.handle}</p>
  } else {
    return <p>Welcome -- sign up?</p>
  }
}
export default Home
