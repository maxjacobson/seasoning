import React, { FunctionComponent } from "react"
import { Link } from "@reach/router"

const GoHome: FunctionComponent<Record<string, never>> = () => {
  return (
    <>
      <p>
        <Link to="/">Go home</Link>
      </p>
    </>
  )
}

export default GoHome
