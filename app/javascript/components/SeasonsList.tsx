import { Guest, Show } from "../types"
import React, { FunctionComponent } from "react"
import { Link } from "react-router-dom"
import { SeenSeasonCheckbox } from "./SeenSeasonCheckbox"

interface Props {
  show: Show
  guest: Guest
}

export const SeasonsList: FunctionComponent<Props> = ({ show, guest }: Props) => {
  return (
    <table className="w-full">
      <thead>
        <tr>
          <th className="text-left">Name</th>
          <th className="text-left">Episode count</th>
          {guest.authenticated && <th className="text-left">Seen?</th>}
        </tr>
      </thead>

      <tbody>
        {show.seasons.map((season) => {
          return (
            <tr key={season.id}>
              <td>
                <Link key={season.id} to={`/shows/${show.slug}/${season.slug}`}>
                  {season.name}
                </Link>
              </td>
              <td>{season.episode_count}</td>
              {guest.authenticated && (
                <td>
                  <SeenSeasonCheckbox guest={guest} show={show} season={season} />
                </td>
              )}
            </tr>
          )
        })}
      </tbody>
    </table>
  )
}
