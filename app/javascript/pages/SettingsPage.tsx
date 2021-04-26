import React, { FunctionComponent, useEffect, useState } from "react"
import { Page, Card, Checkbox, Select, Spinner } from "@shopify/polaris"
import { RouteComponentProps } from "@reach/router"

import { AuthenticatedGuest, Guest, HumanSettings, Visibility } from "../types"
import { setHeadTitle } from "../hooks"

interface LoadingSettingsData {
  loading: true
}

interface LoadedSettingsData {
  loading: false
  settings: HumanSettings
}

type SettingsData = LoadingSettingsData | LoadedSettingsData

interface Props extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

export const SettingsPage: FunctionComponent<Props> = (props) => {
  setHeadTitle("Settings")

  return (
    <Page title="Settings">
      <SettingsBody {...props} />
    </Page>
  )
}

const SettingsBody: FunctionComponent<Props> = (props: Props) => {
  return (
    <Card sectioned>
      {props.guest.authenticated ? (
        <EditSettings guest={props.guest} setLoading={props.setLoading} />
      ) : (
        <Card sectioned>
          <Card.Section>
            <p>You need to log in to edit your settings!</p>
          </Card.Section>
        </Card>
      )}
    </Card>
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
    return <Spinner accessibilityLabel="Loading settings" />
  }

  return (
    <>
      <Card.Section title="Profile page">
        <Checkbox
          label={"Share the shows I'm currently watching"}
          checked={settingsData.settings.share_currently_watching}
          onChange={(value) => update({ share_currently_watching: value })}
          disabled={currentlyUpdating}
        />
      </Card.Section>

      <Card.Section title="Reviews">
        <Select
          label="Who should new reviews be visible to?"
          helpText="This is just a default for new reviews, you can pick another visibility on a review-by-review basis!"
          options={[
            { label: "Anybody", value: "anybody" },
            { label: "Mutual follows", value: "mutuals" },
            { label: "Only myself", value: "myself" },
          ]}
          onChange={(value: Visibility) => update({ default_review_visibility: value })}
          value={settingsData.settings.default_review_visibility}
        />
      </Card.Section>
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
