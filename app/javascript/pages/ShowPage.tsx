import React, { useEffect, useState, FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { Page, SkeletonPage, Card, Stack } from "@shopify/polaris"

import { Guest, YourShow } from "../types"
import { setHeadTitle } from "../hooks"
import { AddShowButton } from "../components/AddShowButton"
import { ChooseShowStatusButton } from "../components/ChooseShowStatusButton"
import { NoteToSelf } from "../components/NoteToSelf"
import { SeasonsList } from "../components/SeasonsList"
import { Poster } from "../components/Poster"

interface Props extends RouteComponentProps {
  showSlug?: string
  guest: Guest
  setLoading: (loadingState: boolean) => void
}

type LoadingShowData = {
  loading: true
  data: null
}

type LoadedShowData = {
  loading: false
  data: YourShow
}

type ShowData = LoadingShowData | LoadedShowData

export const ShowPage: FunctionComponent<Props> = ({ showSlug, guest, setLoading }: Props) => {
  const [showData, setShowData] = useState<ShowData>({
    loading: true,
    data: null,
  })
  useEffect(() => {
    if (!showSlug) {
      return
    }

    setLoading(true)
    ;(async () => {
      let headers
      if (guest.authenticated) {
        headers = { "X-SEASONING_TOKEN": guest.token }
      } else {
        headers = {}
      }
      const response = await fetch(`/api/shows/${showSlug}.json`, {
        headers: headers,
      })

      setLoading(false)

      if (response.ok) {
        const data: YourShow = await response.json()
        setShowData({ loading: false, data: data })
      } else {
        throw new Error("Could not load show")
      }
    })()
  }, [showSlug])

  setHeadTitle(showData.loading ? undefined : showData.data.show.title, [showData])

  if (showData.loading) {
    return <SkeletonPage title="Loading show..."></SkeletonPage>
  } else {
    const { data } = showData

    return (
      <Page title={data.show.title}>
        {guest.authenticated && data.your_relationship && (
          <NoteToSelf
            token={guest.token}
            globalSetLoading={setLoading}
            yourShow={data}
            updateYourShow={(newData) => {
              setShowData({ loading: false, data: newData })
            }}
          />
        )}

        <Card sectioned>
          <Card.Header title={data.show.title}>
            <Stack>
              <>
                {guest.authenticated && (
                  <AddShowButton
                    token={guest.token}
                    show={data.show}
                    yourRelationship={data.your_relationship}
                    setYourShow={(yourShow) => {
                      setShowData({ loading: false, data: yourShow })
                    }}
                  />
                )}
              </>
              <>
                {guest.authenticated && data.your_relationship && (
                  <ChooseShowStatusButton
                    token={guest.token}
                    show={data.show}
                    yourRelationship={data.your_relationship}
                    globalSetLoading={setLoading}
                    setYourShow={(yourShow) => {
                      setShowData({ loading: false, data: yourShow })
                    }}
                  />
                )}
              </>
            </Stack>
          </Card.Header>

          <Card.Section title="Poster">
            <Poster show={data.show} size="large" url={data.show.poster_url} />
          </Card.Section>
          <Card.Section title="Seasons">
            <SeasonsList show={data.show} guest={guest} setLoading={setLoading} />
          </Card.Section>
        </Card>
      </Page>
    )
  }
}
