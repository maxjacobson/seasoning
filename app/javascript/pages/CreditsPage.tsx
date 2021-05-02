import React, { FunctionComponent } from "react"
import { Page, Card, DataTable, Link } from "@shopify/polaris"
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
    <>
      <div>
        <img src={icon} width="60" />
      </div>
      <Link url={url} external={true}>
        {name}
      </Link>
    </>
  )
}

export const CreditsPage: FunctionComponent<RouteComponentProps> = () => {
  setHeadTitle("Credits")

  return (
    <Page title="Credits">
      <Card sectioned>
        <Card.Section title="Inspiration">
          <p>
            Obviously this is very much inspired by{" "}
            <Link url="https://letterboxd.com/" external={true}>
              Letterboxd
            </Link>
            .
          </p>
        </Card.Section>
        <Card.Section title="Icons">
          <p>
            Several icons are from{" "}
            <Link url="https://www.toicon.com/" external={true}>
              to [icon]
            </Link>
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
            <Link url="https://www.themoviedb.org/" external={true}>
              The Movie Database
            </Link>
            .
          </p>
        </Card.Section>
        <Card.Section title="Development">
          <p>
            This site is developed by{" "}
            <Link url="https://www.hardscrabble.net" external={true}>
              Max Jacobson
            </Link>
            . The source code is on GitHub at{" "}
            <Link url="https://github.com/maxjacobson/seasoning" external={true}>
              maxjacobson/seasoning
            </Link>
            . Feel free to pitch in and/or roast me. There are no tests. Just going to get ahead of
            that one. Otherwise it&rsquo;s perfect.
          </p>
        </Card.Section>
        <Card.Section title="Design">
          <p>
            The design is 100% just Shopify&rsquo;s design system,{" "}
            <Link url="https://polaris.shopify.com/components/get-started/" external={true}>
              Polaris
            </Link>{" "}
            and I feel the need to acknowledge that.
          </p>
        </Card.Section>
      </Card>
    </Page>
  )
}
