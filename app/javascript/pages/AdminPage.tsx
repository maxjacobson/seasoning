import React, { useContext } from "react"
import { Link, Navigate } from "react-router-dom"
import { GuestContext, SetLoadingContext } from "../contexts"

import { loadData, setHeadTitle } from "../hooks"
import { Human } from "../types"

type AdminData = {
  humansCount: number
  showsCount: number
  seasonsCount: number
  reviewsCount: number
  episodesCount: number
  lastRefreshedTmdbConfigAt: string
  recentHumans: Human[]
}

export const AdminPage = () => {
  const guest = useContext(GuestContext)
  const setLoading = useContext(SetLoadingContext)

  setHeadTitle("Admin")

  const adminData = loadData<AdminData>(guest, `/api/admin.json`, [], setLoading)

  if (adminData.loading) {
    return <p>Loading...</p>
  }

  if (!adminData.data) {
    return <Navigate to="/" />
  }

  return (
    <div>
      <h1>Admin</h1>

      <h2>Stats</h2>

      <ul>
        <li>
          <strong>Humans count: </strong> {adminData.data.humansCount}
        </li>
        <li>
          <strong>Shows count: </strong> {adminData.data.showsCount}
        </li>
        <li>
          <strong>Seasons count: </strong> {adminData.data.seasonsCount}
        </li>
        <li>
          <strong>Reviews count: </strong> {adminData.data.reviewsCount}
        </li>
        <li>
          <strong>Episodes count: </strong> {adminData.data.episodesCount}
        </li>
        <li>
          <strong>Last refreshed TMDB config: </strong> {adminData.data.lastRefreshedTmdbConfigAt}
        </li>
      </ul>

      <h2>Recent humans</h2>
      <ol>
        {adminData.data.recentHumans.map((human) => {
          return (
            <li key={human.handle}>
              <Link to={`/${human.handle}`}>{human.handle}</Link>
            </li>
          )
        })}
      </ol>
    </div>
  )
}
