import React, { FunctionComponent } from "react"
import { DataTable, Link } from "@shopify/polaris"

import { Show } from "../types"

interface Props {
  show: Show
}

const SeasonsList: FunctionComponent<Props> = ({ show }: Props) => {
  return (
    <DataTable
      columnContentTypes={["text", "numeric"]}
      headings={["Name", "Episode count"]}
      rows={show.seasons.map((season) => {
        return [
          <Link key={season.id} url={`/shows/${show.slug}/${season.slug}`}>
            {season.name}
          </Link>,
          season.episode_count,
        ]
      })}
    />
  )
}

export default SeasonsList
