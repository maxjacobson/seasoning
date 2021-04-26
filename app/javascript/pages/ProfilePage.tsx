import React, { useState, useEffect, FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { Card, Page, SkeletonPage, DataTable, Link } from "@shopify/polaris"
import { DateTime } from "luxon"

import { Profile, Guest } from "../types"
import { setHeadTitle } from "../hooks"
import { ShowPoster } from "../components/ShowPoster"

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
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

export const ProfilePage: FunctionComponent<Props> = ({ guest, handle, setLoading }: Props) => {
  const [profile, setProfile] = useState<ProfileData>({ loading: true })

  setHeadTitle(handle)

  useEffect(() => {
    const headers: Record<string, string> = {}
    if (guest.authenticated) {
      headers["X-SEASONING-TOKEN"] = guest.token
    }
    setLoading(true)
    fetch(`/api/profiles/${handle}.json`, { headers: headers })
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
    const { created_at, currently_watching, your_relationship } = profile.profile

    return (
      <Page
        title={handle}
        primaryAction={
          guest.authenticated &&
          your_relationship &&
          !your_relationship.self && {
            content: "Follow",
            disabled: your_relationship.you_follow_them,
            onAction: async () => {
              const response = await fetch("/api/follows.json", {
                method: "POST",
                headers: {
                  "X-SEASONING-TOKEN": guest.token,
                  "Content-Type": "application/json",
                },
                body: JSON.stringify({
                  followee: handle,
                }),
              })

              if (!response.ok) {
                throw new Error("Could not follow")
              }

              const data = await response.json()

              setProfile({ loading: false, profile: data.profile })
            },
          }
        }
      >
        <Card title="Profile" sectioned>
          <Card.Section title="About">
            <p>
              <em>Seasoner since {DateTime.fromISO(created_at).toLocaleString()}</em>
            </p>
          </Card.Section>

          {currently_watching && (
            <Card.Section title="Currently watching">
              {currently_watching.length ? (
                <DataTable
                  columnContentTypes={["text"]}
                  headings={["Show"]}
                  rows={currently_watching.map((show) => {
                    return [
                      <>
                        <Link key={show.id} url={`/shows/${show.slug}`}>
                          <div>
                            <ShowPoster show={show} size="small" />
                          </div>
                          {show.title}
                        </Link>
                      </>,
                    ]
                  })}
                />
              ) : (
                <p>{handle} is not currently watching anything</p>
              )}
            </Card.Section>
          )}
        </Card>
      </Page>
    )
  }
}
