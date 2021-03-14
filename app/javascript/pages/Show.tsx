import React, { useEffect, useState, FunctionComponent } from "react"
import { RouteComponentProps } from "@reach/router"
import { Guest, Show } from "../types"
import { setHeadTitle } from "../hooks"
import Loader from "../components/Loader"
import AddShowButton from "../components/AddShowButton"
interface Props extends RouteComponentProps {
  showSlug?: string
  guest?: Guest
}

type LoadingShowData = {
  loading: true
  show: null
}

type LoadedShowData = {
  loading: false
  show: Show
}

type ShowData = LoadingShowData | LoadedShowData

const Show: FunctionComponent<Props> = ({ showSlug, guest }: Props) => {
  const [showData, setShowData] = useState<ShowData>({
    loading: true,
    show: null,
  })

  useEffect(() => {
    if (!showSlug) {
      return
    }

    ;(async () => {
      const response = await fetch(`/api/shows/${showSlug}.json`)

      if (response.ok) {
        const data = await response.json()
        setShowData({ loading: false, show: data.show })
      } else {
        throw new Error("Could not load show")
      }
    })()
  }, [showSlug])

  setHeadTitle(showData.show ? showData.show.title : undefined, [showData.show])

  if (showData.loading) {
    return <Loader />
  }

  const { show } = showData

  return (
    <>
      <h2>
        {show.title}{" "}
        {guest?.authenticated ? (
          <AddShowButton token={guest.token} show={show} />
        ) : (
          <></>
        )}
      </h2>
      {show.number_of_seasons === 1 ? (
        <p>1 season</p>
      ) : (
        <p>{show.number_of_seasons} seasons</p>
      )}
    </>
  )
}

export default Show
