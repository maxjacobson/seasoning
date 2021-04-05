import React, { FunctionComponent } from "react"
import { Page, Card, DataTable } from "@shopify/polaris"
import { RouteComponentProps } from "@reach/router"

import { setHeadTitle } from "../hooks"
import Logo from "../images/logo.svg"
import Say from "../images/say.svg"

interface IconLinkProps {
  name: string
  url: string
  icon: string
}
const IconLink: FunctionComponent<IconLinkProps> = ({ name, url, icon }: IconLinkProps) => {
  return (
    <a href={url} target="_blank" rel="noopener noreferrer">
      <div>
        <img src={icon} width="60" />
      </div>
      {name}
    </a>
  )
}

const Credits: FunctionComponent<RouteComponentProps> = () => {
  setHeadTitle("Credits")

  return (
    <Page title="Credits" breadcrumbs={[{ url: "/" }]}>
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
        <Card.Section title="Icons">
          <p>
            Several icons are from{" "}
            <a href="https://www.toicon.com/" target="_blank" rel="noopner noreferrer">
              to [icon]
            </a>
            :
          </p>
          <DataTable
            columnContentTypes={["text", "text"]}
            headings={["Icon", "Artist"]}
            rows={[
              [
                <IconLink
                  key="to-watch"
                  name="to watch"
                  url="https://www.toicon.com/icons/avocado_watch"
                  icon={Logo}
                />,
                "Shannon E Thomas",
              ],
              [
                <IconLink
                  key="to-say"
                  name="to say"
                  url="https://www.toicon.com/icons/avocado_say"
                  icon={Say}
                />,
                "Shannon E Thomas",
              ],
            ]}
          />
        </Card.Section>
        <Card.Section title="Data">
          <p>
            All data from{" "}
            <a href="https://www.themoviedb.org/" target="_blank" rel="noopener noreferrer">
              The Movie Database
            </a>
            .
          </p>
        </Card.Section>
      </Card>
    </Page>
  )
}

export default Credits
