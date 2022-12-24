import React, { useContext } from "react"
import { Link, useParams } from "react-router-dom"

import { Human } from "../types"
import { loadData, setHeadTitle } from "../hooks"
import { GuestContext, SetLoadingContext } from "../contexts"

export const ProfileFollowingPage = () => {
  const guest = useContext(GuestContext)
  const setLoading = useContext(SetLoadingContext)
  const { handle } = useParams()
  setHeadTitle(`${handle}'s follows`)

  const followingData = loadData<{ humans: Human[] }>(
    guest,
    `/api/profiles/${handle}/following.json`,
    [],
    setLoading
  )

  if (followingData.loading) {
    return <div>Loading...</div>
  }

  if (!followingData.data) {
    return <div>Not found</div>
  }

  if (followingData.data.humans.length === 0) {
    return (
      <>
        <div>
          <h1>{handle}&rsquo;s follows</h1>
          <p>None yet!</p>
        </div>
      </>
    )
  }

  return (
    <div>
      <h1>{handle}&rsquo;s follows</h1>
      <ol>
        {followingData.data.humans.map((human) => {
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
