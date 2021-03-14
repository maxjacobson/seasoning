import React, { useEffect, useState, FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"

import { Guest, YourShow } from "../types"
import { setHeadTitle } from "../hooks"
import Loader from "../components/Loader"
import AddShowButton from "../components/AddShowButton"
import NoteToSelf from "../components/NoteToSelf"

interface Props extends RouteComponentProps {
  showSlug?: string
  guest: Guest
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

const Show: FunctionComponent<Props> = ({ showSlug, guest }: Props) => {
  const [showData, setShowData] = useState<ShowData>({
    loading: true,
    data: null,
  })

  useEffect(() => {
    if (!showSlug) {
      return
    }

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

      if (response.ok) {
        const data: YourShow = await response.json()
        setShowData({ loading: false, data: data })
      } else {
        throw new Error("Could not load show")
      }
    })()
  }, [showSlug])

  setHeadTitle(showData.loading ? undefined : showData.data.show.title, [
    showData.loading,
  ])

  if (showData.loading) {
    return <Loader />
  }

  const { data } = showData

  return (
    <>
      <h2>
        {data.show.title}{" "}
        {guest.authenticated ? (
          <AddShowButton
            token={guest.token}
            show={data.show}
            yourRelationship={data.your_relationship}
            setYourShow={(yourShow) => {
              setShowData({ loading: false, data: yourShow })
            }}
          />
        ) : (
          <></>
        )}
      </h2>
      {guest.authenticated && data.your_relationship && (
        <NoteToSelf
          show={data.show}
          yourRelationship={data.your_relationship}
          token={guest.token}
        />
      )}

      {data.show.number_of_seasons === 1 ? (
        <p>1 season</p>
      ) : (
        <p>{data.show.number_of_seasons} seasons</p>
      )}
    </>
  )
}

export default Show
