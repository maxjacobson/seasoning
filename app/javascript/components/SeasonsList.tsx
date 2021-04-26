import React, { FunctionComponent } from "react"
import { DataTable, Link } from "@shopify/polaris"

import { Show, Guest } from "../types"
import { SeenSeasonCheckbox } from "./SeenSeasonCheckbox"

interface Props {
  show: Show
  guest: Guest
  setLoading: (_: boolean) => void
}

export const SeasonsList: FunctionComponent<Props> = ({ show, guest, setLoading }: Props) => {
  return (
    <DataTable
      columnContentTypes={guest.authenticated ? ["text", "numeric", "text"] : ["text", "numeric"]}
      headings={
        guest.authenticated ? ["Name", "Episode count", "Seen?"] : ["Name", "Episode count"]
      }
      rows={show.seasons.map((season) => {
        const items = [
          <Link key={season.id} url={`/shows/${show.slug}/${season.slug}`}>
            {season.name}
          </Link>,
          season.episode_count,
        ]

        if (guest.authenticated) {
          items.push(
            <>
              <SeenSeasonCheckbox
                setLoading={setLoading}
                guest={guest}
                show={show}
                season={season}
                labelHidden={true}
              />
            </>
          )
        }

        return items
      })}
    />
  )
}
