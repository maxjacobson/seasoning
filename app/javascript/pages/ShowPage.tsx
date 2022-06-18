import React, { FunctionComponent, useEffect, useState } from "react"
import { useParams } from "react-router-dom"

import { Guest, YourShow } from "../types"
import { setHeadTitle } from "../hooks"
import { AddShowButton } from "../components/AddShowButton"
import { ChooseShowStatusButton } from "../components/ChooseShowStatusButton"
import { NoteToSelf } from "../components/NoteToSelf"
import { SeasonsList } from "../components/SeasonsList"
import { Poster } from "../components/Poster"

interface Props {
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

export const ShowPage: FunctionComponent<Props> = ({ guest, setLoading }: Props) => {
  const { showSlug } = useParams()
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
    return (
      <div>
        <h1>Loading show...</h1>
      </div>
    )
  } else {
    const { data } = showData

    return (
      <div>
        <h1>{data.show.title}</h1>

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

        <div>
          <h2>{data.show.title}</h2>
          <div>
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
          </div>
        </div>

        <div>
          <h2>Poster</h2>
          <Poster show={data.show} size="large" url={data.show.poster_url} />
        </div>
        <div>
          <h2>Seasons</h2>
          <SeasonsList show={data.show} guest={guest} setLoading={setLoading} />
        </div>
      </div>
    )
  }
}
