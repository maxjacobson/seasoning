import React, { FunctionComponent } from "react"
import { Page, Card } from "@shopify/polaris"
import { RouteComponentProps } from "@reach/router"

import { setHeadTitle } from "../hooks"

const Credits: FunctionComponent<RouteComponentProps> = () => {
  setHeadTitle("Credits")

  return (
    <Page title="Credits">
      <Card sectioned>
        <Card.Section title="Inspiration">
          <p>
            Obviously this is very much inspired by{" "}
            <a href="https://letterboxd.com/" target="_blank" rel="noopener noreferrer">
              Letterboxd
            </a>
            .
          </p>
        </Card.Section>
        <Card.Section title="Logos">
          <p>
            The logo is adapted from{" "}
            <em>
              <a
                href="https://www.toicon.com/icons/avocado_watch"
                target="_blank"
                rel="noopener noreferrer"
              >
                to watch
              </a>
            </em>{" "}
            by Shannon E Thomas.
          </p>
        </Card.Section>
      </Card>
    </Page>
  )
}

export default Credits
