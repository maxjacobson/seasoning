import React, { FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { Page } from "@shopify/polaris"
import GetStarted from "./Home/GetStarted"
import YourShows from "./Home/YourShows"

import { Guest } from "../types"

interface HomeProps extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

const Home: FunctionComponent<HomeProps> = (props: HomeProps) => {
  const { guest, setLoading } = props

  return (
    <Page title="Welcome" subtitle="This is seasoning, a website about TV shows">
      {guest.authenticated ? (
        <YourShows human={guest.human} token={guest.token} globalSetLoading={setLoading} />
      ) : (
        <GetStarted globalSetLoading={setLoading} />
      )}
    </Page>
  )
}
export default Home
