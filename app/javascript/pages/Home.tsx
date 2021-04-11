import React, { FunctionComponent } from "react"
import { navigate, RouteComponentProps } from "@reach/router"
import { Page, Spinner } from "@shopify/polaris"
import GetStarted from "./Home/GetStarted"

import { Guest } from "../types"

interface HomeProps extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

const Home: FunctionComponent<HomeProps> = (props: HomeProps) => {
  const { guest, setLoading } = props

  if (guest.authenticated) {
    navigate("/shows")

    return (
      <Page>
        <Spinner />
      </Page>
    )
  } else {
    return (
      <Page title="Welcome" subtitle="This is seasoning, a website about TV shows">
        <GetStarted globalSetLoading={setLoading} />
      </Page>
    )
  }
}
export default Home
