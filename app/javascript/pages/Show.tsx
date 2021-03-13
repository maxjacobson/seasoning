import React, { useEffect, useState } from "react"
import { RouteComponentProps } from "@reach/router"
import { Guest, Show } from "../types"
import { setHeadTitle } from "../hooks"
import Loader from "../components/Loader"
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

const Show = ({ showSlug, guest }: Props) => {
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
      <h2>{show.title}</h2>
      <p>There are {show.number_of_seasons} seasons</p>
      <p>Show pages goes here!</p>
    </>
  )
}

export default Show
