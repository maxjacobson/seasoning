import React, { useState, useEffect, FunctionComponent } from "react"
import { RouteComponentProps, navigate } from "@reach/router"
import { Card, Page, SkeletonPage, DataTable, Link, Tabs, SkeletonBodyText } from "@shopify/polaris"
import { DateTime } from "luxon"

import { Profile, Guest, SeasonReview, Show } from "../types"
import { setHeadTitle, loadData } from "../hooks"
import { ShowPoster } from "../components/ShowPoster"
import { SeasonReviewSummary } from "../components/SeasonReviewSummary"

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
  tab: 0 | 1
}

export const ProfilePage: FunctionComponent<Props> = ({
  guest,
  handle,
  setLoading,
  tab,
}: Props) => {
  const [profileData, setProfile] = useState<ProfileData>({ loading: true })

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

  if (profileData.loading) {
    return <SkeletonPage></SkeletonPage>
  } else if (!profileData.profile) {
    return (
      <Page>
        <Card title="Not found" sectioned>
          <p>No one goes by that name around these parts</p>
        </Card>
      </Page>
    )
  } else {
    const { profile } = profileData

    return (
      <Page
        title={handle}
        primaryAction={
          guest.authenticated &&
          profile.your_relationship &&
          !profile.your_relationship.self && {
            content: "Follow",
            disabled: profile.your_relationship.you_follow_them,
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
          <Tabs
            tabs={[
              {
                id: "about",
                content: "About",
                accessibilityLabel: "About",
                panelID: "about",
              },
              {
                id: "reviews",
                content: "Reviews",
                panelID: "reviews",
              },
            ]}
            selected={tab}
            onSelect={(newTab) => {
              let url = `/${handle}`

              if (newTab === 1) {
                url = `${url}/reviews`
              }

              navigate(url)
            }}
          >
            {renderTab(tab, profile, guest, setLoading)}
          </Tabs>
        </Card>
      </Page>
    )
  }
}

const renderTab = (
  selectedTab: number,
  profile: Profile,
  guest: Guest,
  setLoading: (_: boolean) => void
) => {
  if (selectedTab === 0) {
    return <AboutTab profile={profile} />
  } else if (selectedTab === 1) {
    return <ReviewsTab profile={profile} guest={guest} setLoading={setLoading} />
  } else {
    return <div>Unknown tab???</div>
  }
}

interface AboutTabProps {
  profile: Profile
}

const AboutTab = ({ profile }: AboutTabProps) => {
  return (
    <>
      <Card.Section title="About">
        <p>
          <em>Seasoner since {DateTime.fromISO(profile.created_at).toLocaleString()}</em>
        </p>
      </Card.Section>

      {profile.currently_watching && (
        <Card.Section title="Currently watching">
          {profile.currently_watching.length ? (
            <DataTable
              columnContentTypes={["text"]}
              headings={["Show"]}
              rows={profile.currently_watching.map((show) => {
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
            <p>{profile.handle} is not currently watching anything</p>
          )}
        </Card.Section>
      )}
    </>
  )
}

interface ReviewsTabProps {
  profile: Profile
  guest: Guest
  setLoading: (_: boolean) => void
}

const ReviewsTab = ({ profile, guest, setLoading }: ReviewsTabProps) => {
  const reviewsData = loadData<{ reviews: { review: SeasonReview; show: Show }[] }>(
    guest,
    `/api/profiles/${profile.handle}/season-reviews.json`,
    [],
    setLoading
  )

  if (reviewsData.loading) {
    return (
      <Card.Section>
        <SkeletonBodyText />
      </Card.Section>
    )
  }

  if (!reviewsData.data || reviewsData.data.reviews.length === 0) {
    return (
      <>
        <Card.Section>
          <p>No reviews yet!</p>
        </Card.Section>
      </>
    )
  }

  return (
    <Card.Section>
      {reviewsData.data.reviews.map(({ review, show }) => {
        return <SeasonReviewSummary review={review} show={show} key={review.id} />
      })}
    </Card.Section>
  )
}
