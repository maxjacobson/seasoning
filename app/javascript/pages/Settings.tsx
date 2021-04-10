import React, { FunctionComponent, useEffect, useState } from "react"
import { Page, Card, Checkbox, Spinner } from "@shopify/polaris"
import { RouteComponentProps } from "@reach/router"

import { AuthenticatedGuest, Guest, HumanSettings } from "../types"
import { setHeadTitle } from "../hooks"

interface Props extends RouteComponentProps {
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

const Settings: FunctionComponent<Props> = (props) => {
  setHeadTitle("Settings")

  return (
    <Page title="Settings" breadcrumbs={[{ url: "/" }]}>
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

interface LoadingSettingsData {
  loading: true
}

interface LoadedSettingsData {
  loading: false
  settings: HumanSettings
}

type SettingsData = LoadingSettingsData | LoadedSettingsData

interface EditSettingsProps {
  guest: AuthenticatedGuest
  setLoading: (loadingState: boolean) => void
}

const EditSettings: FunctionComponent<EditSettingsProps> = ({
  guest,
  setLoading,
}: EditSettingsProps) => {
  const [settingsData, setSettingsData] = useState<SettingsData>({ loading: true })
  const [currentlyUpdating, setCurrentlyUpdating] = useState(false)

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

  if (settingsData.loading) {
    return <Spinner accessibilityLabel="Loading settings" />
  }

  return (
    <Card.Section title="Profile page">
      <Checkbox
        label={"Share the shows I'm currently watching"}
        checked={settingsData.settings.share_currently_watching}
        onChange={async (value) => {
          setCurrentlyUpdating(true)
          setLoading(true)
          const response = await updateMySettings(guest.token, {
            share_currently_watching: value,
          })
          setCurrentlyUpdating(false)
          setLoading(false)

          if (response.ok) {
            const data: HumanSettings = await response.json()
            setSettingsData({ loading: false, settings: data })
          } else {
            throw new Error("Could not update settings")
          }
        }}
        disabled={currentlyUpdating}
      />
    </Card.Section>
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

export default Settings
