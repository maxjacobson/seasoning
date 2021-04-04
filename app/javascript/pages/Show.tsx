import React, { useEffect, useState, FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { Page, SkeletonPage, Card, Stack } from "@shopify/polaris"

import { Guest, YourShow } from "../types"
import { setHeadTitle } from "../hooks"
import AddShowButton from "../components/AddShowButton"
import ChooseShowStatusButton from "../components/ChooseShowStatusButton"
import NoteToSelf from "../components/NoteToSelf"
import ShowPoster from "../components/ShowPoster"

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

const Show: FunctionComponent<Props> = ({ showSlug, guest, setLoading }: Props) => {
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
      <Page>
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

          <Card.Section>
            <ShowPoster show={data.show} size="large" />

            {guest.authenticated && data.your_relationship && (
              <div>
                <NoteToSelf
                  token={guest.token}
                  globalSetLoading={setLoading}
                  yourShow={data}
                  updateYourShow={(newData) => {
                    setShowData({ loading: false, data: newData })
                  }}
                />
              </div>
            )}

            <p>Info about show to come</p>
          </Card.Section>
        </Card>
      </Page>
    )
  }
}

export default Show
