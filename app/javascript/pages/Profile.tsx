import React, { useState, useEffect, FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { Card, Page, SkeletonPage } from "@shopify/polaris"
import { DateTime } from "luxon"

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
  setLoading: (loadingState: boolean) => void
}

const Profile: FunctionComponent<Props> = ({ handle, setLoading }: Props) => {
  const [profile, setProfile] = useState<ProfileData>({ loading: true })

  setHeadTitle(handle)

  useEffect(() => {
    setLoading(true)
    fetch(`/api/profiles/${handle}.json`)
      .then((response) => {
        setLoading(false)
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
    return <SkeletonPage></SkeletonPage>
  } else if (!profile.profile) {
    return (
      <Page>
        <Card title="Not found" sectioned>
          <p>No one goes by that name around these parts</p>
        </Card>
      </Page>
    )
  } else {
    const { created_at } = profile.profile

    return (
      <Page>
        <Card title={handle} sectioned>
          <Card.Section title="About">
            <p>
              <em>Seasoner since {DateTime.fromISO(created_at).toLocaleString()}</em>
            </p>
          </Card.Section>

          <Card.Section title="Hmm">
            <p>
              Welcome to <strong>{handle}</strong>&rsquo;s profile page. What should go here? Later
              on, when people can write reviews, or share their favorite shows, that will probably
              go here.
            </p>
          </Card.Section>
        </Card>
      </Page>
    )
  }
}

export default Profile
