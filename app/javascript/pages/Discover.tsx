import React from "react"
import { RouteComponentProps } from "@reach/router"
import { Guest } from "../types"

interface Props extends RouteComponentProps {
  guest?: Guest
}

const Discover = (props: Props) => {
  return (
    <>
      <h2>Discover</h2>
      <p>Discover page content to come later...</p>
    </>
  )
}
export default Discover
