import React, { FunctionComponent } from "react"
import { Link } from "@shopify/polaris"

const GoHome: FunctionComponent<Record<string, never>> = () => {
  return (
    <>
      <p>
        <Link url="/">Go home</Link>
      </p>
    </>
  )
}

export default GoHome
