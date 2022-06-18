import React, { FunctionComponent } from "react"
import { Link } from "react-router-dom"
import { Guest, Show } from "../types"
import { SeenSeasonCheckbox } from "./SeenSeasonCheckbox"

interface Props {
  show: Show
  guest: Guest
  setLoading: (_: boolean) => void
}

export const SeasonsList: FunctionComponent<Props> = ({ show, guest, setLoading }: Props) => {
  return (
    <table style={{ width: "100%" }}>
      <thead>
        <tr>
          <th style={{ textAlign: "left" }}>Name</th>
          <th style={{ textAlign: "left" }}>Episode count</th>
          {guest.authenticated && <th style={{ textAlign: "left" }}>Seen?</th>}
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
                  <SeenSeasonCheckbox
                    setLoading={setLoading}
                    guest={guest}
                    show={show}
                    season={season}
                    labelHidden={true}
                  />
                </td>
              )}
            </tr>
          )
        })}
      </tbody>
    </table>
  )
}
