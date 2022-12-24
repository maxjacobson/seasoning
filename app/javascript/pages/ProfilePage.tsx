import React, { useContext, useEffect, useState } from "react"
import { Link, useParams } from "react-router-dom"

import styled from "@emotion/styled"

import { Profile } from "../types"
import { setHeadTitle } from "../hooks"
import { Poster } from "../components/Poster"
import { GuestContext, SetLoadingContext } from "../contexts"

const CurrentlyWatchingContainer = styled.div`
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
`

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

export const ProfilePage = () => {
  const [profileData, setProfile] = useState<ProfileData>({ loading: true })
  const { handle } = useParams()
  const guest = useContext(GuestContext)
  const setLoading = useContext(SetLoadingContext)

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
    return <div>Loading...</div>
  } else if (!profileData.profile) {
    return (
      <div>
        <h1>Not found</h1>
        <p>No one goes by that name around these parts</p>
      </div>
    )
  } else {
    const { profile } = profileData

    return (
      <div>
        <h1>{handle}</h1>

        {guest.authenticated && profile.your_relationship && !profile.your_relationship.self && (
          <button
            disabled={profile.your_relationship.you_follow_them}
            onClick={async () => {
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
            }}
          >
            {profile.your_relationship.you_follow_them ? "Following" : "Follow"}
          </button>
        )}
        <div>
          <h2>Profile</h2>

          <>
            <div>
              <h2>About</h2>
              <p>
                <em>Seasoner since {new Date(profile.created_at).toLocaleDateString()}</em>
              </p>
            </div>

            {profile.currently_watching && (
              <div>
                <h2>Currently watching</h2>
                {profile.currently_watching.length ? (
                  <CurrentlyWatchingContainer>
                    {profile.currently_watching.map((show) => {
                      return (
                        <div key={show.id}>
                          <Link to={`/shows/${show.slug}`}>
                            <div>
                              <Poster show={show} size="small" url={show.poster_url} />
                            </div>
                            {show.title}
                          </Link>
                        </div>
                      )
                    })}
                  </CurrentlyWatchingContainer>
                ) : (
                  <p>{profile.handle} is not currently watching anything</p>
                )}
              </div>
            )}

            <h2>See also</h2>
            <ul>
              <li>
                <Link to={`/${handle}/reviews`}>{handle}&rsquo;s reviews</Link>
              </li>
              <li>
                <Link to={`/${handle}/followers`}>{handle}&rsquo;s followers</Link>
              </li>
              <li>
                <Link to={`/${handle}/following`}>{handle}&rsquo;s follows</Link>
              </li>
            </ul>
          </>
        </div>
      </div>
    )
  }
}
