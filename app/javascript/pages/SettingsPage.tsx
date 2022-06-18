import React, { FunctionComponent, useContext, useEffect, useState } from "react"

import { AuthenticatedGuest, HumanSettings } from "../types"
import { setHeadTitle } from "../hooks"
import { GuestContext } from "../contexts"

interface LoadingSettingsData {
  loading: true
}

interface LoadedSettingsData {
  loading: false
  settings: HumanSettings
}

type SettingsData = LoadingSettingsData | LoadedSettingsData

interface Props {
  setLoading: (loadingState: boolean) => void
}

export const SettingsPage: FunctionComponent<Props> = (props) => {
  setHeadTitle("Settings")

  return (
    <div>
      <h1>Settings</h1>
      <SettingsBody {...props} />
    </div>
  )
}

const SettingsBody: FunctionComponent<Props> = (props: Props) => {
  const guest = useContext(GuestContext)

  return (
    <div>
      {guest.authenticated ? (
        <EditSettings guest={guest} setLoading={props.setLoading} />
      ) : (
        <div>
          <p>You need to log in to edit your settings!</p>
        </div>
      )}
    </div>
  )
}

interface EditSettingsProps {
  guest: AuthenticatedGuest
  setLoading: (loadingState: boolean) => void
}

const EditSettings: FunctionComponent<EditSettingsProps> = ({
  guest,
  setLoading,
}: EditSettingsProps) => {
  const [currentlyUpdating, setCurrentlyUpdating] = useState(false)
  const [settingsData, setSettingsData] = useState<SettingsData>({ loading: true })

  useEffect(() => {
    ;(async () => {
      setLoading(true)
      const response = await fetch("/api/settings.json", {
        headers: {
          "X-SEASONING-TOKEN": guest.token,
        },
      })
      setLoading(false)

      if (response.ok) {
        const data: HumanSettings = await response.json()
        setSettingsData({ loading: false, settings: data })
      } else {
        throw new Error("Could not load settings")
      }
    })()
  }, [])

  const update = async (patch: Record<string, unknown>) => {
    setCurrentlyUpdating(true)
    setLoading(true)
    const response = await updateMySettings(guest.token, patch)
    setCurrentlyUpdating(false)
    setLoading(false)

    if (response.ok) {
      const data: HumanSettings = await response.json()
      setSettingsData({ loading: false, settings: data })
    } else {
      throw new Error("Could not update settings")
    }
  }

  if (settingsData.loading) {
    return <div>Loading settings...</div>
  }

  return (
    <>
      <div>
        <h2>Profile page</h2>
        <input
          type="checkbox"
          name="share-currently-watching"
          id="share-currently-watching"
          checked={settingsData.settings.share_currently_watching}
          disabled={currentlyUpdating}
          onChange={() =>
            update({ share_currently_watching: !settingsData.settings.share_currently_watching })
          }
        />

        <label htmlFor="share-currently-watching">
          Share the shows I&rsquo;m currently watching
        </label>
      </div>

      <div>
        <h2>Reviews</h2>

        <div>
          <label>Who should new reviews be visible to?</label>
        </div>
        <select
          value={settingsData.settings.default_review_visibility}
          onChange={(event) => {
            update({ default_review_visibility: event.target.value })
          }}
          disabled={currentlyUpdating}
        >
          <option value="anybody">Anybody</option>
          <option value="mutuals">Mutual follows</option>
          <option value="myself">Only myself</option>
        </select>
        <p>
          This is just a default for new reviews, you can pick another visibility on a
          review-by-review basis!
        </p>
      </div>
    </>
  )
}

const updateMySettings = (token: string, body: Record<string, unknown>): Promise<Response> => {
  return fetch("/api/settings.json", {
    method: "PATCH",
    body: JSON.stringify(body),
    headers: {
      "X-SEASONING-TOKEN": token,
      "Content-Type": "application/json",
    },
  })
}
