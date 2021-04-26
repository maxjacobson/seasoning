import React, { FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { Page, Card, Link } from "@shopify/polaris"
import { YourShowsList } from "../components/YourShowsList"

import { Guest } from "../types"

interface Props extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

export const YourShowsPage: FunctionComponent<Props> = (props: Props) => {
  const { guest, setLoading } = props

  return (
    <Page title="Your shows">
      {guest.authenticated ? (
        <YourShowsList human={guest.human} token={guest.token} globalSetLoading={setLoading} />
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
