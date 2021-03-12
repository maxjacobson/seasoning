import React, { useState, useEffect } from "react"
import { RouteComponentProps } from "@reach/router"
import Loader from "../components/Loader"
import { Show } from "../types"
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
  profile: {
    handle: string
    shows: Show[]
  }
}

type ProfileData = StillLoading | LoadedProfileData | ProfileNotFound

interface Props extends RouteComponentProps {
  handle?: string
}

const Profile = ({ handle }: Props) => {
  const [profile, setProfile] = useState<ProfileData>({ loading: true })

  if (handle) {
    setHeadTitle(handle)
  }

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
      .then((data) => {
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

  return <p>Profile page for {handle}</p>
}

export default Profile
