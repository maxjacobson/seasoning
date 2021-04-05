import React, { FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { Page, Card } from "@shopify/polaris"

import { Guest } from "../types"

interface Props extends RouteComponentProps {
  showSlug?: string
  seasonSlug?: string
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

const Season: FunctionComponent<Props> = ({ showSlug, seasonSlug }: Props) => {
  return (
    <Page title={showSlug} subtitle={seasonSlug} breadcrumbs={[{ url: `/shows/${showSlug}` }]}>
      <Card sectioned>
        <Card.Header title="Something goes here"></Card.Header>
        <Card.Section title="Season info">
          <p>Something</p>
        </Card.Section>
      </Card>
    </Page>
  )
}

export default Season
