import React, { FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { Page, Card, Link } from "@shopify/polaris"
import YourShows from "../components/YourShows"

import { Guest } from "../types"

interface Props extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

const Home: FunctionComponent<Props> = (props: Props) => {
  const { guest, setLoading } = props

  return (
    <Page title="Your shows">
      {guest.authenticated ? (
        <YourShows human={guest.human} token={guest.token} globalSetLoading={setLoading} />
      ) : (
        <Card>
          <Card.Section>
            <Link url="/">Go home</Link>
          </Card.Section>
        </Card>
      )}
    </Page>
  )
}
export default Home
