import React from "react"
import { RouteComponentProps } from "@reach/router"
import { Guest } from "../types"
import { setHeadTitle } from "../hooks"

interface Props extends RouteComponentProps {
  showSlug?: string
  guest?: Guest
}

const Show = ({ showSlug, guest }: Props) => {
  setHeadTitle(showSlug)

  return (
    <>
      <h2>{showSlug}</h2>
      <p>Show pages goes here!</p>
    </>
  )
}

export default Show
