import React, { useEffect, useState, FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { Page, SkeletonPage, Card } from "@shopify/polaris"

import { Guest, YourShow } from "../types"
import { setHeadTitle } from "../hooks"
import AddShowButton from "../components/AddShowButton"
import NoteToSelf from "../components/NoteToSelf"

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

  setHeadTitle(showData.loading ? undefined : showData.data.show.title, [showData.loading])

  if (showData.loading) {
    return <SkeletonPage title="Loading show..."></SkeletonPage>
  } else {
    const { data } = showData

    return (
      <Page title={data.show.title}>
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
        <Card sectioned>
          {guest.authenticated && data.your_relationship && (
            <Card.Section>
              <NoteToSelf
                token={guest.token}
                globalSetLoading={setLoading}
                yourShow={data}
                updateYourShow={(newData) => {
                  setShowData({ loading: false, data: newData })
                }}
              />
            </Card.Section>
          )}

          <Card.Section>
            {data.show.number_of_seasons === 1 ? (
              <p>1 season</p>
            ) : (
              <p>{data.show.number_of_seasons} seasons</p>
            )}
          </Card.Section>
        </Card>
      </Page>
    )
  }
}

export default Show
