import React, { useState, useEffect, FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { DateTime } from "luxon"

import Loader from "../components/Loader"
import { Profile } from "../types"
import { setHeadTitle } from "../hooks"

interface StillLoading {
  loading: true
}

interface ProfileNotFound {
  loading: false
  profile: null
}

interface LoadedProfileData {
  loading: false
  profile: Profile
}

type ProfileData = StillLoading | LoadedProfileData | ProfileNotFound

interface Props extends RouteComponentProps {
  handle?: string
}

const Profile: FunctionComponent<Props> = ({ handle }: Props) => {
  const [profile, setProfile] = useState<ProfileData>({ loading: true })

  setHeadTitle(handle)

  useEffect(() => {
    fetch(`/api/profiles/${handle}.json`)
      .then((response) => {
        if (response.ok) {
          return response.json()
        } else if (response.status === 404) {
          throw new Error("Not found")
        } else {
          throw new Error("Could not fetch profile")
        }
      })
      .then((data: { profile: Profile }) => {
        setProfile({
          loading: false,
          profile: data.profile,
        })
      })
      .catch((err) => {
        if (err.message === "Not found") {
          setProfile({
            loading: false,
            profile: null,
          })
        } else {
          throw err
        }
      })
  }, [handle])

  if (profile.loading) {
    return <Loader />
  }

  if (!profile.profile) {
    return <p>Not found: {handle}</p>
  }

  const { created_at } = profile.profile

  return (
    <>
      <h1>{handle}</h1>
      <p>
        <em>Seasoner since {DateTime.fromISO(created_at).toLocaleString()}</em>
      </p>
      <p>
        Welcome to {handle}&rsquo;s profile page. What should go here? Later on, when people can
        write reviews, or share their favorite shows, that will probably go here.
      </p>
    </>
  )
}

export default Profile
