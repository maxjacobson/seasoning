import React from "react"
import { RouteComponentProps } from "@reach/router"
import { Guest } from "../types"

interface Props extends RouteComponentProps {
  guest?: Guest
}

const Discover = (props: Props) => {
  return <p>Discover page</p>
}
export default Discover
